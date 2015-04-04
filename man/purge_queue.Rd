\name{PurgeQueue}
\alias{purge_queue}
\title{Purge a queue}
\description{Purge an SQS queue of its message}
\usage{
purge_queue(queue, ...)
}
\arguments{
  \item{queue}{A character string containing a queue URL, or the name of the queue.}
  \item{...}{Additional arguments passed to \code{\link{sqsHTTP}}.}
}
\details{Purge an SQS queue of its messages, without deleting it. Use \code{\link{delete_queue}} to delete the queue entirely.}
\value{If successful, a logical \code{TRUE} value. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.}
\references{\href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_PurgeeQueue.html}{PurgeeQueue}}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{link{create_queue}}
\code{\link{delete_queue}}
}
%\examples{}
