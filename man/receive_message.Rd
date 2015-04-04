\name{receive_msg}
\alias{receive_msg}
\title{receive_msg}
\description{Receive one or more messages from an SQS queue}
\usage{
receive_msg(queue, attributes = NULL, n = 1, timeout = NULL, wait = NULL, ...)
}
\arguments{
  \item{queue}{A character string containing a queue URL, or the name of the queue.}
  \item{attributes}{}
  \item{n}{The number of messages to retrieve (maximum 10).}
  \item{timeout}{A number of seconds to make the message invisible to subsequent \code{receive_msg} requests. This modifies the queue's default visibility timeout.}
  \item{wait}{A number of seconds to wait for messages before responding to the request.}
  \item{...}{Additional arguments passed to \code{\link{sqsHTTP}}.}
}
\details{Receive one or more messages from an SQS queue.}
\value{}
\references{\href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_ReceiveMessage.html}{ReceiveMessage}}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{link{send_msg}}
\code{link{delete_msg}}
}
%\examples{}
