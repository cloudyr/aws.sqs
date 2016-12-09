#' @rdname queues
#' @title Create or delete a queue
#' @description Create or delete an SQS queue
#' @param name A character string containing a name for the queue.
#' @param attributes Currently ignored
#' @param queue A character string containing a queue URL, or the name of the queue.
#' @param query A list specifying additional query arguments to be passed to the \code{query} argument of \code{\link{sqsHTTP}}.
#' @param ... Additional arguments passed to \code{\link{sqsHTTP}}.
#' @return If successful, \code{create_queue} returns a character string containing an SQS Queue URL and \code{delete_queue} returns a logical \code{TRUE}. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.
#' @author Thomas J. Leeper
#' @details \code{create_queue} creates a new SQS queue; \code{delete_queue} deletes a queue.
#' @examples
#' \dontrun{
#'   # list current queues
#'   list_queues()
#'   
#'   # create a queue
#'   queue <- create_queue("ExampleQueue")
#'   get_queue_url("ExampleQueue")
#'   
#'   # send message to queue
#'   send_msg("ExampleQueue", "This is a test message")
#'   # receive a message
#'   (m <- receive_msg("ExampleQueue", timeout = 0))
#'   
#'   # delete a message from queue
#'   delete_msg("ExampleQueue", m$ReceiptHandle[1])
#'   
#'   # delete queue
#'   delete_queue("ExampleQueue")
#'   
#' }
#' @references
#' \href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_CreateQueue.html}{CreateQueue}
#' \href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_DeleteQueue.html}{DeleteQueue}
#' @seealso \code{\link{get_queue_attrs}} \code{\link{set_queue_attrs}} \code{link{purge_queue}}
#' @export
create_queue <- function(name, attributes = NULL, query = NULL, ...) {
    out <- sqsHTTP(query = c(query, list(Action = "CreateQueue", QueueName = name)), ...)
    if (inherits(out, "aws-error")) {
        return(out)
    }
    structure(out$CreateQueueResponse$CreateQueueResult$QueueUrl,
              RequestId = out$CreateQueueResponse$ResponseMetadata$RequestId)
}

#' @rdname queues
#' @export
delete_queue <- function(queue, query = NULL, ...) {
    queue <- .urlFromName(queue)
    out <- sqsHTTP(url = queue, query = c(query, list(Action = "DeleteQueue")), ...)
    if (inherits(out, "aws-error")) {
        return(out)
    }
    structure(TRUE, RequestId = out$DeleteQueueResponse$ResponseMetadata$RequestId)
}

#' @title Purge a queue
#' @aliases purge_queue
#' @description Purge an SQS queue of its message
#' @details Purge an SQS queue of its messages, without deleting it. Use \code{\link{delete_queue}} to delete the queue entirely.
#' @param queue A character string containing a queue URL, or the name of the queue.
#' @param query A list specifying additional query arguments to be passed to the \code{query} argument of \code{\link{sqsHTTP}}.
#' @param ... Additional arguments passed to \code{\link{sqsHTTP}}.
#' @return If successful, a logical \code{TRUE} value. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.
#' @author Thomas J. Leeper
#' @seealso \code{link{create_queue}} \code{\link{delete_queue}}
#' @references
#' \href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_PurgeeQueue.html}{PurgeQueue}
#' @export
purge_queue <- function(queue, query = NULL, ...) {
    queue <- .urlFromName(queue)
    out <- sqsHTTP(url = queue, query = c(query, list(Action = "PurgeQueue")), ...)
    if (inherits(out, "aws-error")) {
        return(out)
    }
    structure(TRUE, RequestId = out$PurgeQueueResponse$ResponseMetadata$RequestId)
}
