#' @title Create a queue
#' @aliases create_queue
#' @description Create an SQS queue
#' @details Create a new SQS queue.
#' @param name A character string containing a name for the queue.
#' @param attributes Currently ignored
#' @param ... Additional arguments passed to \code{\link{sqsHTTP}}.
#' @return If successful, a character string containing an SQS Queue URL.
#' Otherwise, a data structure of class \dQuote{aws_error} containing any error
#' message(s) from AWS and information about the request attempt.
#' @author Thomas J. Leeper
#' @seealso \code{link{delete_queue}} \code{\link{get_queue_attrs}}
#' \code{\link{set_queue_attrs}}
#' @references
#' \href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_CreateQueue.html}{CreateQueue}
#' @export
create_queue <- function(name, attributes = NULL, ...) {
    out <- sqsHTTP(query = list(Action = "CreateQueue", QueueName = name), ...)
    if (inherits(out, "aws-error")) {
        return(out)
    }
    structure(out$CreateQueueResponse$CreateQueueResult$QueueUrl,
              RequestId = out$CreateQueueResponse$ResponseMetadata$RequestId)
}

#' @title Delete a queue
#' @aliases delete_queue
#' @description Delete an SQS queue
#' @details Delete an SQS queue. Use \code{\link{purge_queue}} to remove all messages
#' from a queue without deleting it.
#' @param queue A character string containing a queue URL, or the name of the
#' queue.
#' @param ... Additional arguments passed to \code{\link{sqsHTTP}}.
#' @return If successful, a logical \code{TRUE} value. Otherwise, a data
#' structure of class \dQuote{aws_error} containing any error message(s) from
#' AWS and information about the request attempt.
#' @author Thomas J. Leeper
#' @seealso \code{link{create_queue}} \code{\link{purge_queue}}
#' @references
#' \href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_DeleteQueue.html}{DeleteQueue}
#' @export
delete_queue <- function(queue, ...) {
    queue <- .urlFromName(queue)
    out <- sqsHTTP(url = queue, query = list(Action = "DeleteQueue"), ...)
    if (inherits(out, "aws-error")) {
        return(out)
    }
    structure(TRUE, RequestId = out$DeleteQueueResponse$ResponseMetadata$RequestId)
}

#' @title Purge a queue
#' @description Purge an SQS queue of its message
#' @details Purge an SQS queue of its messages, without deleting it. Use
#' \code{\link{delete_queue}} to delete the queue entirely.
#' 
#' @aliases purge_queue
#' @param queue A character string containing a queue URL, or the name of the
#' queue.
#' @param ... Additional arguments passed to \code{\link{sqsHTTP}}.
#' @return If successful, a logical \code{TRUE} value. Otherwise, a data
#' structure of class \dQuote{aws_error} containing any error message(s) from
#' AWS and information about the request attempt.
#' @author Thomas J. Leeper
#' @seealso \code{link{create_queue}} \code{\link{delete_queue}}
#' @references
#' \href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_PurgeeQueue.html}{PurgeQueue}
purge_queue <- function(queue, ...) {
    queue <- .urlFromName(queue)
    out <- sqsHTTP(url = queue, query = list(Action = "PurgeQueue"), ...)
    if (inherits(out, "aws-error")) {
        return(out)
    }
    structure(TRUE, RequestId = out$PurgeQueueResponse$ResponseMetadata$RequestId)
}
