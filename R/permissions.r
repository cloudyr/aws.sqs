#' @rdname permissions
#' @title Change queue permissions
#' @description Add or remove queue permissions
#' @details Add or removes a permission from an SQS queue.
#' @param queue A character string containing a queue URL, or the name of the queue.
#' @param label A character string containing a unique label for the permission.
#' @param principal A character vector containing the AWS account number of the principal who will be given permission. Principals and actions must be specified one-to-one or one-to-many.
#' @param action A character vector containing an SQS permission. Valid values include: \dQuote{*}, \dQuote{SendMessage}, \dQuote{ReceiveMessage}, \dQuote{DeleteMessage}, \dQuote{ChangeMessageVisibility}, \dQuote{GetQueueAttributes}, \dQuote{GetQueueUrl}.
#' @param query A list specifying additional query arguments to be passed to the \code{query} argument of \code{\link{sqsHTTP}}.
#' @param ... Additional arguments passed to \code{\link{sqsHTTP}}.
#' @return A list.
#' @author Thomas J. Leeper
#' @seealso \code{link{create_queue}} \code{\link{get_queue_attrs}} \code{\link{set_queue_attrs}}
#' @references
#' \href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_AddPermission.html}{AddPermission}
#' \href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_RemovePermission.html}{RemovePermission}
#' @importFrom stats setNames
#' @export
add_queue_permission <- function(queue, label, principal, action, query = NULL, ...) {
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
    if (!any(action %in% v)) {
        stop("Unrecogized 'action':", paste0(action[!action %in% v], collapse = ", "))
    }
    a <- paste0("ActionName.", seq_along(action))
    b <- paste0("AWSAccountId.", seq_along(principal))
    if (nchar(label) > 80) {
        stop("'label' must be no more than 80 characters")
    }
    query <- c(query, list(Action = "AddPermission", Label = label))
    query <- c(query, setNames(as.list(action), a), setNames(as.list(principal), b))
    queue <- .urlFromName(queue)
    out <- sqsHTTP(url = queue, query = query, ...)
    if (inherits(out, "aws-error")) {
        return(out)
    }
    out
}

#' @rdname permissions
#' @export
remove_queue_permission <- function(queue, label, query = NULL, ...) {
    queue <- .urlFromName(queue)
    out <- sqsHTTP(url = queue, query = c(query, list(Action = "RemovePermission", Label = label)), ...)
    if (inherits(out, "aws-error")) {
        return(out)
    }
    out
}
