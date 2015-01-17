add_permission <- function(queue, label, principal, action, ...) {
    queue <- .urlFromName(queue)
    out <- sqsHTTP(url = queue, query = list(Action = "AddPermission"), ...)
    if(inherits(out, "aws-error"))
        return(out)
    out
}

remove_permission <- function(queue, label, ...) {
    queue <- .urlFromName(queue)
    out <- sqsHTTP(url = queue, query = list(Action = "RemovePermission"), ...)
    if(inherits(out, "aws-error"))
        return(out)
    out
}
