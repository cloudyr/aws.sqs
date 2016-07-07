#' @title Receive message
#' @description Receive one or more messages from an SQS queue
#' @param queue A character string containing a queue URL, or the name of the
#' queue.
#' @param attributes Currently ignored.
#' @param n The number of messages to retrieve (maximum 10).
#' @param timeout A number of seconds to make the message invisible to
#' subsequent \code{receive_msg} requests. This modifies the queue's default
#' visibility timeout. See \code{\link{visibility}} to modify this value after
#' receiving a message.
#' @param wait A number of seconds to wait for messages before responding to
#' the request.
#' @param ... Additional arguments passed to \code{\link{sqsHTTP}}.
#' @return A data.frame of messages.
#' @author Thomas J. Leeper
#' @seealso \code{link{send_msg}} \code{link{delete_msg}}
#' @references
#' \href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_ReceiveMessage.html}{ReceiveMessage}
#' @export
receive_msg <- function(queue, attributes = NULL, n = 1, timeout = NULL, wait = NULL, ...) {
    queue <- .urlFromName(queue)
    query_args <- list(Action = "ReceiveMessage")
    if (n > 10) {
        query_args$MaxNumberOfMessages <- 10L
        warning("Maxmimum 'n' exceeded so 10 used by default")
    } else if (n < 1) {
        stop("Only positive 'n' values can be retrieved")
    } else {
        query_args$MaxNumberOfMessages <- round(n, 0)
    }
    if (!is.null(timeout)) {
        query_args$VisibilityTimeout <- round(timeout, 0)
    }
    if (!is.null(wait)) {
        w <- as.integer(round(wait, 0))
        query_args$WaitTimeSeconds <- w
        out <- sqsHTTP(url = queue, query = query_args, ...)
    } else {
        out <- sqsHTTP(url = queue, query = query_args, ...)
    }
    if (inherits(out, "aws-error") || inherits(out, "unknown")) {
        return(out)
    }
    out2 <- out$ReceiveMessageResponse$ReceiveMessageResult$messages
    if (!length(out2)) {
        out2 <- data.frame(Attributes = character(0),
                           Body = character(0),
                           MD5OfBody = character(0),
                           MD5OfMessageAttributes = character(0),
                           MessageAttributes = character(0),
                           MessageId = character(0),
                           ReceiptHandle = character(0),
                           stringsAsFactors = FALSE)
    }
    structure(out2, 
              RequestId = out$ReceiveMessageResponse$ResponseMetadata$RequestId)
}



#' @title delete_msg
#' @description Delete one or more messages from an SQS queue
#' @details Delete one or more messages from an SQS queue. If a message is not deleted,
#' it remains visible in the queue and will be returned by subsequent calls to
#' \code{\link{receive_msg}}.
#' @param queue A character string containing a queue URL, or the name of the
#' queue.
#' @param handle A message handle, as returned by \code{\link{receive_msg}}.
#' @param ... Additional arguments passed to \code{\link{sqsHTTP}}.
#' @return If operation succeeds, a logical \code{TRUE}.
#' @author Thomas J. Leeper
#' @seealso \code{link{receive_msg}}
#' @references
#' \href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_DeleteMessage.html}{DeleteMessage}
#' 
#' \href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_DeleteMessageBatch.html}{DeleteMessageBatch}
#' @export
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



#' send_msg
#' 
#' Send a message to an SQS queue
#' 
#' Send a new message to an SQS queue.
#' 
#' @param queue A character string containing a queue URL, or the name of the
#' queue.
#' @param msg A character vector containing one or more message bodies.
#' @param attributes Currently ignored. (If \code{msg} is of length one, a
#' specification of message attributes. Ignored otherwise.)
#' @param delay A numeric value indicating the number of seconds between 0 and
#' 900 to delay a specific message. If \code{NULL}, the default value for the
#' queue applies.
#' @param ... Additional arguments passed to \code{\link{sqsHTTP}}.
#' @return A list of message information, including the MessageId and an MD5
#' checksum of the message body.
#' @author Thomas J. Leeper
#' @seealso \code{link{receive_msg}} \code{link{delete_msg}}
#' @references
#' \href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_SendMessage.html}{SendMessage}
#' 
#' \href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_SendMessageBatch.html}{SendMessageBatch}
send_msg <- function(queue, msg, query = list(), attributes = NULL, delay = NULL, ...) {
    queue <- .urlFromName(queue)
    if(length(msg) > 1) {
        # batch mode
        query_args <- append(query, list(Action = "SendMessageBatch"))
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
        query_args <- append(query, list(Action = "SendMessage"))
        query_args$MessageBody = msg
        out <- sqsHTTP(url = queue, query = query_args, ...)
        if (inherits(out, "aws-error") || inherits(out, "unknown")) {
            return(out)
        }
        structure(list(out$SendMessageResponse$SendMessageResult),
                  RequestId = out$SendMessageResponse$ResponseMetadata$RequestId)
    }
}
