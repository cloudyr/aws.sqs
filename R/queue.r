create_queue <- function(name, attributes, ...) {
    out <- sqsHTTP(query = list(Action = "CreateQueue", QueueName = name), ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(out$CreateQueueResponse$CreateQueueResult$QueueUrl,
              RequestId = out$CreateQueueResponse$ResponseMetadata$RequestId)
}

delete_queue <- function(queue, ...) {
    queue <- .urlFromName(queue)
    out <- sqsHTTP(url = queue, query = list(Action = "DeleteQueue"), ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(TRUE, RequestId = out$DeleteQueueResponse$ResponseMetadata$RequestId)
}

purge_queue <- function(queue, ...) {
    queue <- .urlFromName(queue)
    out <- sqsHTTP(url = queue, query = list(Action = "PurgeQueue"), ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(list(), RequestId = out$PurgeQueueResponse$ResponseMetadata$RequestId)
}
