receive_msg <- function(queue, attributes = NULL, n = 1, timeout = NULL, wait = NULL, ...) {
    queue <- .urlFromName(queue)
    query_args <- list(Action = "ReceiveMessage")
    if(n > 10) {
        query_args$MaxNumberOfMessages <- 10L
        warning("Maxmimum 'n' exceeded so 10 used by default")
    } else if(n < 1) {
        stop("Only positive 'n' values can be retrieved")
    } else {
        query_args$MaxNumberOfMessages <- round(n, 0)
    }
    if(!is.null(timeout))
        query_args$VisibilityTimeout <- round(timeout, 0)
    if(!is.null(wait)) {
        w <- as.integer(round(wait, 0))
        query_args$WaitTimeSeconds <- w
        out <- sqsHTTP(url = queue, query = query_args, ...)
    } else {
        out <- sqsHTTP(url = queue, query = query_args, ...)
    }
    if (inherits(out, "aws-error") || inherits(out, "unknown")) {
        return(out)
    }
    structure(out$ReceiveMessageResponse$ReceiveMessageResult$messages, 
              RequestId = out$ReceiveMessageResponse$ResponseMetadata$RequestId)
}

delete_msg <- function(queue, handle, ...) {
    queue <- .urlFromName(queue)
    if (length(handle) > 1) {
        # batch mode
        query_args <- list(action = "DeleteMessageBatch")
        n <- 1:length(handle)
        id <- paste0("msg", n)
        a <- as.list(c(id, handle))
        names(a) <- c(paste0("DeleteMessageBatchRequestEntry.",n,".Id"),
                      paste0("DeleteMessageBatchRequestEntry.",n,".ReceiptHandle"))
        query_args <- c(query_args, a)
    } else {
        # single mode
        query_args <- list(ReceiptHandle = handle, Action = "DeleteMessage")
    }
    out <- sqsHTTP(url = queue, query = query_args, ...)
    if (inherits(out, "aws-error") || inherits(out, "unknown")) {
        return(out)
    }
    structure(TRUE, RequestId = out$DeleteMessageResponse$ResponseMetadata$RequestId)
}

send_msg <- function(queue, msg, attributes = NULL, delay = NULL, ...) {
    queue <- .urlFromName(queue)
    if(length(msg) > 1) {
        # batch mode
        query_args <- list(Action = "SendMessageBatch")
        n <- 1:length(msg)
        id <- paste0("msg", n)
        a <- as.list(c(id, msg))
        names(a) <- c(paste0("DeleteMessageBatchRequestEntry.",n,".Id"),
                      paste0("DeleteMessageBatchRequestEntry.",n,".ReceiptHandle"))
        query_args <- c(query_args, a)
        out <- sqsHTTP(url = queue, query = query_args, ...)
        if (inherits(out, "aws-error") || inherits(out, "unknown")) {
            return(out)
        }
        structure(out$SendMessageBatchResponse$SendMessageBatchResult,
                  RequestId = out$SendMessageBatchResponse$ResponseMetadata$RequestId)
    } else {
        # single mode
        query_args <- list(Action = "SendMessage")
        query_args$MessageBody = msg
        out <- sqsHTTP(url = queue, query = query_args, ...)
        if (inherits(out, "aws-error") || inherits(out, "unknown")) {
            return(out)
        }
        structure(list(out$SendMessageResponse$SendMessageResult),
                  RequestId = out$SendMessageResponse$ResponseMetadata$RequestId)
    }
}
