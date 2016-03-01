sqsHTTP <- function(url = NULL, 
                    query = list(), 
                    region = Sys.getenv("AWS_DEFAULT_REGION", "us-east-1"), 
                    key = Sys.getenv("AWS_ACCESS_KEY_ID"), 
                    secret = Sys.getenv("AWS_SECRET_ACCESS_KEY"), 
                    ...) {
    if (is.null(url)) {
        url <- paste0("https://sqs.",region,".amazonaws.com")
    }
    p <- parse_url
    p <- parse_url(url)
    action <- if(p$path == "") "/" else paste0("/",p$path)
    d_timestamp <- format(Sys.time(), "%Y%m%dT%H%M%SZ", tz = "UTC")
    if (key == "") {
        H <- add_headers(`x-amz-date` = d_timestamp)
    } else {
        S <- signature_v4_auth(
               datetime = d_timestamp,
               region = region,
               service = "sqs",
               verb = "GET",
               action = action,
               query_args = query,
               canonical_headers = list(host = paste0("sqs.",region,".amazonaws.com"),
                                        `x-amz-date` = d_timestamp),
               request_body = "",
               key = key, secret = secret)
        H <- add_headers(`x-amz-date` = d_timestamp, 
                         `x-amz-content-sha256` = S$BodyHash,
                         Authorization = S$SignatureHeader)
    }
    
    if (length(query)) {
        r <- GET(url, H, query = query, ...)
    } else {
        r <- GET(url, H, ...)
    }

    cont <- content(r, "text", encoding = "UTF-8")
    if (tolower(http_status(r)$category) == "client error") {
        x <- try(xmlToList(xmlParse(cont)), silent = TRUE)
        if (inherits(x, "try-error")) {
            x <- try(fromJSON(cont)$Error, silent = TRUE)
        }
        warning(paste0(http_status(r)$message, ": ", x$Code, " (", x$Message, ")"))
        h <- headers(r)
        out <- structure(x, headers = h, class = "aws_error")
        attr(out, "request_canonical") <- S$CanonicalRequest
        attr(out, "request_string_to_sign") <- S$StringToSign
        attr(out, "request_signature") <- S$SignatureHeader
    } else {
        out <- try(fromJSON(cont), silent = TRUE)
        if (inherits(out, "try-error")) {
            out2 <- try(xmlToList(xmlParse(cont)), silent = TRUE)
            if (inherits(out2, "try-error")) {
                out <- structure(cont, class = "unknown")
            } else {
                out <- out2
            }
            
        }
    }
    return(out)
}
