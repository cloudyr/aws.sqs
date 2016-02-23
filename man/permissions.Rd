\name{Permissions}
\alias{add_permission}
\alias{remove_permission}
\title{Change queue permissions}
\description{Add or remove queue permissions}
\usage{
add_permission(queue, label, principal, action, ...)

remove_permission(queue, label, ...)
}
\arguments{
  \item{queue}{A character string containing a queue URL, or the name of the queue.}
  \item{label}{A character string containing a unique label for the permission.}
  \item{principal}{A character vector containing the AWS account number of the principal who will be given permission. Principals and actions must be specified one-to-one or one-to-many.}
  \item{action}{A character vector containing an SQS permission. Valid values include: \dQuote{*}, \dQuote{SendMessage}, \dQuote{ReceiveMessage}, \dQuote{DeleteMessage}, \dQuote{ChangeMessageVisibility}, \dQuote{GetQueueAttributes}, \dQuote{GetQueueUrl}.}
  \item{...}{Additional arguments passed to \code{\link{sqsHTTP}}.}
}
\details{Add or removes a permission from an SQS queue.}
\value{A list.}
\references{
\href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_AddPermission.html}{AddPermission}
\href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_RemovePermission.html}{RemovePermission}
}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{link{create_queue}}
\code{\link{get_queue_attrs}}
\code{\link{set_queue_attrs}}
}
%\examples{}
