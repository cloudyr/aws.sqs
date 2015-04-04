\name{send_msg}
\alias{send_msg}
\title{send_msg}
\description{Send a message to an SQS queue}
\usage{
send_msg(queue, msg, attributes = NULL, delay = NULL, ...)
}
\arguments{
  \item{queue}{A character string containing a queue URL, or the name of the queue.}
  \item{msg}{}
  \item{attributes}{}
  \item{delay}{}
  \item{...}{Additional arguments passed to \code{\link{sqsHTTP}}.}
}
\details{Send a new message to an SQS queue.}
\value{}
\references{\href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_SendMessage.html}{SendMessage}}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{link{receive_msg}}
\code{link{delete_msg}}
}
%\examples{}
