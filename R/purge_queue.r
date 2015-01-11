purge_queue <- function(queue, ...) {
    queue <- .urlFromName(queue)
    out <- sqsHTTP(url = queue, query = list(Action = "PurgeQueue"), ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(list(), RequestId = out$PurgeQueueResponse$ResponseMetadata$RequestId)
}
