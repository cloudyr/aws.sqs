get_queue_attrs <- function(queue, attributes = "All", ...) {
    queue <- .urlFromName(queue)
    query_args <- list(Action = "GetQueueAttributes")
    a <- as.list(attributes)
    names(a) <- paste0("Attribute.Name.",1:length(a))
    query_args <- c(query_args, a)
    out <- sqsHTTP(queue, query = query_args, ...)
    if (inherits(out, "aws-error") || inherits(out, "unknown")) {
        return(out)
    }
    x <- out$GetQueueAttributesResponse$GetQueueAttributesResult
    result <- setNames(sapply(x, `[[`, "Value"), sapply(x, `[[`, "Name"))
    structure(result,
              RequestId = out$GetQueueAttributesResponse$ResponseMetadata$RequestId)
}

set_queue_attrs <- function(queue, attributes, ...) {
    queue <- .urlFromName(queue)
    query_args <- list(Action = "SetQueueAttributes")
    a <- length(attributes)
    query_args <- c(query_args, 
                    setNames(names(attributes), 
                             paste0("Attribute.Name.", seq_along(attributes))),
                    setNames(unname(unlist(attributes)),
                             paste0("Attribute.Value.", seq_along(attributes))) )
    out <- sqsHTTP(url = queue, query = query_args, ...)
    if (inherits(out, "aws-error") || inherits(out, "unknown")) {
        return(out)
    }
    structure(TRUE,
              RequestId = out$SetQueueAttributesResponse$ResponseMetadata$RequestId)
}

get_queue_url <- function(name, owner = NULL, ...) {
    query_args <- list(Action = "GetQueueUrl", QueueName = name)
    if(!is.null(owner))
        query_args$QueueOwnerAWSAccountId <- owner
    out <- sqsHTTP(query = query_args, ...)
    if (inherits(out, "aws-error") || inherits(out, "unknown")) {
        return(out)
    }
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
