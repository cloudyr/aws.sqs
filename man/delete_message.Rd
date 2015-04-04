\name{delete_msg}
\alias{delete_msg}
\title{delete_msg}
\description{Delete one or more messages from an SQS queue}
\usage{
delete_msg_msg(queue, handle, ...)
}
\arguments{
  \item{queue}{A character string containing a queue URL, or the name of the queue.}
  \item{handle}{A message handle, as returned by \code{\link{receive_message}}.}
  \item{...}{Additional arguments passed to \code{\link{sqsHTTP}}.}
}
\details{Delete one or more messages from an SQS queue. If a message is not deleted, it remains visible in the queue and will be returned by subsequent calls to \code{\link{receive_message}}.}
\value{}
\references{\href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_DeleteMessage.html}{DeleteMessage}}

\references{\href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_DeleteMessageBatch.html}{DeleteMessageBatch}}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{link{receive_msg}}
}
%\examples{}
