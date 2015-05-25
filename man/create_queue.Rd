\name{CreateQueue}
\alias{create_queue}
\title{Create a queue}
\description{Create an SQS queue}
\usage{
create_queue(name, attributes = NULL, ...)
}
\arguments{
  \item{name}{A character string containing a name for the queue.}
  \item{attributes}{Currently ignored}
  \item{...}{Additional arguments passed to \code{\link{sqsHTTP}}.}
}
\details{Create a new SQS queue.}
\value{If successful, a character string containing an SQS Queue URL. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.}
\references{\href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_CreateQueue.html}{CreateQueue}}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{link{delete_queue}}
\code{\link{get_queue_attrs}}
\code{\link{set_queue_attrs}}
}
%\examples{}
