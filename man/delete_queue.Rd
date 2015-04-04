\name{DeleteQueue}
\alias{delete_queue}
\title{Delete a queue}
\description{Delete an SQS queue}
\usage{
delete_queue(queue, ...)
}
\arguments{
  \item{queue}{A character string containing a queue URL, or the name of the queue.}
  \item{...}{Additional arguments passed to \code{\link{sqsHTTP}}.}
}
\details{Delete an SQS queue. Use \code{\link{purge_queue}} to remove all messages from a queue without deleting it.}
\value{If successful, a logical \code{TRUE} value. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.}
\references{\href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_DeleteQueue.html}{DeleteQueue}}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{link{create_queue}}
\code{\link{purge_queue}}
}
%\examples{}
