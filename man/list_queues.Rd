\name{list_queues}
\alias{list_queues}
\title{list_queues}
\description{List SQS queues}
\usage{
list_queues(starts_with = NULL, ...)
}
\arguments{
  \item{starts_with}{An optional character string describing the beginning of the name of queues to retrieve.}
  \item{...}{Additional arguments passed to \code{\link{sqsHTTP}}.}
}
\details{List all SQS queue associated with an AWS account, or only those starting with a particular character string.}
\value{}
\references{\href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_ListQueues.html}{ListQueues}}
\author{Thomas J. Leeper}
%\note{}
%\seealso{}
%\examples{}
