\name{list_queues}
\alias{list_queues}
\alias{deadletter_queues}
\title{list_queues}
\description{List SQS queues}
\usage{
list_queues(starts_with = NULL, ...)

deadletter_queues(...)
}
\arguments{
  \item{starts_with}{An optional character string describing the beginning of the name of queues to retrieve.}
  \item{...}{Additional arguments passed to \code{\link{sqsHTTP}}.}
}
\details{
For \code{list_queues}, a list of all SQS queue associated with an AWS account, or only those starting with a particular character string.

For \code{deadletter_queues}, a list of all SQS queues with a RedrivePolicy queue attribute configured with a dead letter queue.
}
\value{If successful, a character vector containing queue URLs. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.}
\references{
\href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_ListQueues.html}{ListQueues}

\href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_ListDeadLetterSourceQueues.html}{ListDeadLetterSourceQueues}
}
\author{Thomas J. Leeper}
%\note{}
%\seealso{}
%\examples{}
