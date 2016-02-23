add_permission <- function(queue, label, principal, action, ...) {
    if ((length(action) != length(principal))) {
        if ((length(action) == 1) & (length(principal) > 1)) {
            action <- rep(action, length(principal))
        } else if ((length(principal) == 1) & (length(action) > 1)) {
            action <- rep(length, length(action))
        } else {
            stop("length of 'action' is not a multiple of length of 'principal', or vice versa")
        }
    }
    v <- c("*", "SendMessage", "ReceiveMessage", "DeleteMessage", "ChangeMessageVisibility", "GetQueueAttributes", "GetQueueUrl")
    if (!any(action) %in% v) {
        stop("Unrecogized 'action':", paste0(action[!action %in% v], collapse = ", "))
    }
    a <- paste0("ActionName.", seq_along(action))
    b <- paste0("AWSAccountId.", seq_along(principal))
    if (nchar(label) > 80) {
        stop("'label' must be no more than 80 characters")
    }
    query <- list(Action = "AddPermission", Label = label)
    query <- c(query, setNames(as.list(action), a), setNames(as.list(principal), b))
    queue <- .urlFromName(queue)
    out <- sqsHTTP(url = queue, query = query, ...)
    if(inherits(out, "aws-error"))
        return(out)
    out
}

remove_permission <- function(queue, label, ...) {
    queue <- .urlFromName(queue)
    out <- sqsHTTP(url = queue, query = list(Action = "RemovePermission", Label = label), ...)
    if(inherits(out, "aws-error"))
        return(out)
    out
}
