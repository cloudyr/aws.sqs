#' @title List queues
#' @description List SQS queues
#' @details For \code{list_queues}, a list of all SQS queue associated with an AWS
#' account, or only those starting with a particular character string.
#' 
#' For \code{deadletter_queues}, a list of all SQS queues with a RedrivePolicy
#' queue attribute configured with a dead letter queue.
#' 
#' @aliases list_queues deadletter_queues
#' @param starts_with An optional character string describing the beginning of the name of queues to retrieve.
#' @param query A list specifying additional query arguments to be passed to the \code{query} argument of \code{\link{sqsHTTP}}.
#' @param ... Additional arguments passed to \code{\link{sqsHTTP}}.
#' @return If successful, a character vector containing queue URLs. Otherwise,
#' a data structure of class \dQuote{aws_error} containing any error message(s)
#' from AWS and information about the request attempt.
#' @author Thomas J. Leeper
#' @references
#' \href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_ListQueues.html}{ListQueues}
#' \href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_ListDeadLetterSourceQueues.html}{ListDeadLetterSourceQueues}
#' @export
list_queues <- function(starts_with = NULL, query = NULL, ...) {
    if (!is.null(starts_with)) {
        out <- sqsHTTP(query = c(query, list(Action = "ListQueues", QueueNamePrefix = starts_with)), ...)
    } else {
        out <- sqsHTTP(query = c(query, list(Action = "ListQueues")), ...)
    }
    if (inherits(out, "aws-error")) {
        return(out)
    }
    structure(out$ListQueuesResponse$ListQueuesResult$queueUrls,
              RequestId = out$ListQueuesResponse$ResponseMetadata$RequestId)
}

deadletter_queues <- function(query = NULL, ...) {
    out <- sqsHTTP(query = c(query, list(Action = "ListDeadLetterSourceQueues")), ...)
    if (inherits(out, "aws-error")) {
        return(out)
    }
    structure(out$ListDeadLetterSourceQueuesResponse$ListDeadLetterSourceQueuesResult$queueUrls,
              RequestId = out$ListDeadLetterSourceQueuesResponse$ResponseMetadata$RequestId)
}
