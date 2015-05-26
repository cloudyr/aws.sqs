\name{send_msg}
\alias{send_msg}
\title{send_msg}
\description{Send a message to an SQS queue}
\usage{
send_msg(queue, msg, attributes = NULL, delay = NULL, ...)
}
\arguments{
  \item{queue}{A character string containing a queue URL, or the name of the queue.}
  \item{msg}{A character vector containing one or more message bodies.}
  \item{attributes}{Currently ignored. (If \code{msg} is of length one, a specification of message attributes. Ignored otherwise.)}
  \item{delay}{A numeric value indicating the number of seconds between 0 and 900 to delay a specific message. If \code{NULL}, the default value for the queue applies.}
  \item{...}{Additional arguments passed to \code{\link{sqsHTTP}}.}
}
\details{Send a new message to an SQS queue.}
\value{A list of message information, including the MessageId and an MD5 checksum of the message body.}
\references{
\href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_SendMessage.html}{SendMessage}

\href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_SendMessageBatch.html}{SendMessageBatch}
}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{link{receive_msg}}
\code{link{delete_msg}}
}
%\examples{}
