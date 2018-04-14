#' @title Execute SQS API Request
#' @description This is the workhorse function to execute calls to the SQS API.
#' @details This function constructs and signs an SQS API request and returns the results thereof, or relevant debugging information in the case of error.
#' @param url A character string containing an SQS API endpoint URL.
#' @param query An optional named list containing query string parameters and their character values.
#' @param headers A list of headers to pass to the HTTP request.
#' @param verbose A logical indicating whether to be verbose. Default is given by \code{options("verbose")}.
#' @param region A character string specifying an AWS region. See \code{\link[aws.signature]{locate_credentials}}.
#' @param key A character string specifying an AWS Access Key. See \code{\link[aws.signature]{locate_credentials}}.
#' @param secret A character string specifying an AWS Secret Key. See \code{\link[aws.signature]{locate_credentials}}.
#' @param session_token Optionally, a character string specifying an AWS temporary Session Token to use in signing a request. See \code{\link[aws.signature]{locate_credentials}}.
#' @param ... Additional arguments passed to \code{\link[httr]{GET}}.
#' @return If successful, a named list. Otherwise, a data structure of class
#' \dQuote{aws_error} containing any error message(s) from AWS and information
#' about the request attempt.
#' @author Thomas J. Leeper
#' @importFrom aws.signature signature_v4_auth
#' @importFrom jsonlite fromJSON
#' @importFrom xml2 read_xml as_list
#' @import httr
#' @export
sqsHTTP <- 
function(
  url = NULL, 
  headers = list(),
  query = list(), 
  verbose = getOption("verbose", FALSE),
  region = Sys.getenv("AWS_DEFAULT_REGION", "us-east-1"), 
  key = NULL, 
  secret = NULL, 
  session_token = NULL,
  ...
) {
    # locate and validate credentials
    credentials <- locate_credentials(key = key, secret = secret, session_token = session_token, region = region, verbose = verbose)
    key <- credentials[["key"]]
    secret <- credentials[["secret"]]
    session_token <- credentials[["session_token"]]
    region <- credentials[["region"]]
    
    # generate request signature
    if (is.null(url)) {
        url <- paste0("https://sqs.",region,".amazonaws.com")
    }
    p <- parse_url(url)
    action <- if(p$path == "") "/" else paste0("/", p$path)
    d_timestamp <- format(Sys.time(), "%Y%m%dT%H%M%SZ", tz = "UTC")
    Sig <- signature_v4_auth(
           datetime = d_timestamp,
           region = region,
           service = "sqs",
           verb = "GET",
           action = action,
           query_args = query,
           canonical_headers = list(host = paste0("sqs.",region,".amazonaws.com"),
                                    `x-amz-date` = d_timestamp),
           request_body = "",
           key = key,
           secret = secret,
           session_token = session_token,
           verbose = verbose)
    # setup request headers
    headers[["x-amz-date"]] <- d_timestamp
    headers[["x-amz-content-sha256"]] <- Sig$BodyHash
    headers[["Authorization"]] <- Sig[["SignatureHeader"]]
    if (!is.null(session_token) && session_token != "") {
        headers[["x-amz-security-token"]] <- session_token
    }
    H <- do.call(add_headers, headers)
    
    # execute request
    if (length(query)) {
        r <- GET(url, H, query = query, ...)
    } else {
        r <- GET(url, H, ...)
    }

    cont <- content(r, "text", encoding = "UTF-8")
    if (http_error(r)) {
        x <- try(as_list(read_xml(cont)), silent = TRUE)
        if (inherits(x, "try-error")) {
            x <- try(jsonlite::fromJSON(cont)$Error, silent = TRUE)
        }
        warning(paste0(http_status(r)$message, ": ", x$Code, " (", x$Message, ")"))
        h <- headers(r)
        out <- structure(x, headers = h, class = "aws_error")
        attr(out, "request_canonical") <- Sig$CanonicalRequest
        attr(out, "request_string_to_sign") <- Sig$StringToSign
        attr(out, "request_signature") <- Sig$SignatureHeader
    } else {
        out <- try(jsonlite::fromJSON(cont), silent = TRUE)
        if (inherits(out, "try-error")) {
            out2 <- try(as_list(read_xml(cont)), silent = TRUE)
            if (inherits(out2, "try-error")) {
                out <- structure(cont, class = "unknown")
            } else {
                out <- out2
            }
            
        }
    }
    return(out)
}
