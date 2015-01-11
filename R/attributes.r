get_attributes <- function(queue, attribute = "All", ...) {
    queue <- .urlFromName(queue)
    query_args <- list(Action = "SetQueueAttributes")
    a <- as.list(attribute)
    names(a) <- paste0("Attribute.Name.",1:length(a))
    query_args <- c(query_args, a)
    out <- sqsHTTP(queue, query = query_args, ...)
    if(inherits(out, "aws-error"))
        return(out)
    return(out)
}

set_attributes <- function(queue, ...) {
    queue <- .urlFromName(queue)
    query_args <- list(Action = "SetQueueAttributes")
    out <- sqsHTTP(url = queue, query_args = query, ...)
    if(inherits(out, "aws-error"))
        return(out)
    return(out)
}

get_queue_url <- function(name, owner = NULL, ...) {
    query_args <- list(Action = "GetQueueUrl", QueueName = name)
    if(!is.null(owner))
        query_args$QueueOwnerAWSAccountId <- owner
    out <- sqsHTTP(query = query_args, ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(out$GetQueueUrlResponse$GetQueueUrlResult$QueueUrl,
              RequestId = out$GetQueueUrlResponse$ResponseMetadata$RequestId)
}

.urlFromName <- function(queue) {
    p <- parse_url(queue)
    if(is.null(p$scheme)) {
        out <- get_queue_url(queue)
        if(!length(out))
            stop("Queue URL not found")
    } else {
        out <- queue
    }
    return(out)
}
