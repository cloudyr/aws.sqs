#' @title Change Visiblity Timeout
#' @description Change the visibility timeout of received message(s)
#' @details Changes the visibility timeout of one or more SQS messages, by their message
#' handle.
#' @param queue A character string containing a queue URL, or the name of the
#' queue.
#' @param handle A character vector containing one or more message handles, as
#' returned by \code{\link{receive_msg}}.
#' @param timeout An integer value indicating the new value of the visibility
#' timeout, in seconds between 0 and 43200, for the message(s).
#' @param ... Additional arguments passed to \code{\link{sqsHTTP}}.
#' @return If successful, a logical \code{TRUE}. Otherwise, a data structure of
#' class \dQuote{aws_error} containing any error message(s) from AWS and
#' information about the request attempt.
#' @author Thomas J. Leeper
#' @seealso \code{link{receive_msg}} \code{link{delete_msg}}
#' @references
#' \href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_ChangeMessageVisibility.html}{ChangeMessageVisibility}
visibility <- function(queue, handle, timeout = NULL, ...) {
    queue <- .urlFromName(queue)
    if (length(handle) > 1) {
        # batch mode
        query_args <- list(Action = "ChangeMessageVisibilityBatch")
        n <- 1:length(handle)
        if (!is.null(timeout)) {
            if (!length(timeout) %in% c(1, length(handle))) {
                stop("Length of 'timeout' must match length of 'handle'")
            } else {
                timeout <- rep(timeout, length(handle))
            }
        }
        id <- paste0("msg", n)
        i1 <- paste0("ChangeMessageVisibilityBatchRequestEntry.",n,".Id")
        i2 <- paste0("ChangeMessageVisibilityBatchRequestEntry.",n,".ReceiptHandle")
        i3 <- if (is.null(timeout)) NULL else paste0("ChangeMessageVisibilityBatchRequestEntry.",n,".VisibilityTimeout")
        a <- as.list(c(id, n, timeout))
        names(a) <- c(i1, i2, i3)
        query_args <- c(query_args, a)
    } else {
        # single mode
        query_args <- list(Action = "ChangeMessageVisibility", 
                           ReceiptHandle = handle)
        if (!is.null(timeout)) {
            query_args$VisibilityTimeout <- timeout
        }
    }
    out <- sqsHTTP(url = queue, query = query_args, ...)
    if (inherits(out, "aws-error")) {
        return(out)
    }
    structure(TRUE,
              RequestId = out$ChangeMessageVisibilityResponse$ResponseMetadata$RequestId)
}
