list_queues <- function(starts_with = NULL, ...) {
    if(!is.null(starts_with))
        out <- sqsHTTP(query = list(Action = "ListQueues", QueueNamePrefix = starts_with), ...)
    else
        out <- sqsHTTP(query = list(Action = "ListQueues"), ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(out$ListQueuesResponse$ListQueuesResult$queueUrls,
              RequestId = out$ListQueuesResponse$ResponseMetadata$RequestId)
}

deadletter_queues <- function(...) {
    out <- sqsHTTP(query = list(Action = "ListDeadLetterSourceQueues"), ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(out$ListDeadLetterSourceQueuesResponse$ListDeadLetterSourceQueuesResult$queueUrls,
              RequestId = out$ListDeadLetterSourceQueuesResponse$ResponseMetadata$RequestId)
}
