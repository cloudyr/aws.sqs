visibility <- function(queue, handle, timeout = NULL, ...) {
    queue <- .urlFromName(queue)
    if(length(handle) > 1) {
        # batch mode
        query_args <- list(Action = "ChangeMessageVisibilityBatch")
        n <- 1:length(handle)
        if(!is.null(timeout)) {
            if(!length(timeout) %in% c(1, length(handle))) {
                stop("Length of 'timeout' must match length of 'handle'")
            } else {
                timeout <- rep(timeout, length(handle))
            }
        }
        id <- paste0("msg", n)
        i1 <- paste0("ChangeMessageVisibilityBatchRequestEntry.",n,".Id")
        i2 <- paste0("ChangeMessageVisibilityBatchRequestEntry.",n,".ReceiptHandle")
        i3 <- if(is.null(timeout)) NULL else paste0("ChangeMessageVisibilityBatchRequestEntry.",n,".VisibilityTimeout")
        a <- as.list(c(id, n, timeout))
        names(a) <- c(i1, i2, i3)
        query_args <- c(query_args, a)
    } else {
        # single mode
        query_args <- list(Action = "ChangeMessageVisibility", 
                           ReceiptHandle = handle)
        if(!is.null(timeout))
            query_args$VisibilityTimeout <- timeout
    }
    out <- sqsHTTP(url = queue, query = query_args, ...)
    if(inherits(out, "aws-error"))
        return(out)
    out
}
