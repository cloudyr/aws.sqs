\name{GetQueueURL}
\alias{get_queue_url}
\title{Get a queue URL}
\description{Get a queue URL by name}
\usage{
get_queue_url(name, owner = NULL, ...)
}
\arguments{
  \item{name}{A character string containing the name of the queue.}
  \item{owner}{A character string containing the AWS Account ID that created the queue.}
  \item{...}{Additional arguments passed to \code{\link{sqsHTTP}}.}
}
\details{Retrieves the URL for an SQS queue by its name.}
\value{If successful, a character string containing an SQS Queue URL. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.}
\references{\href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_GetQueueUrl.html}{GetQueueURL}}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{link{create_queue}}
\code{link{delete_queue}}
\code{\link{get_queue_attrs}}
\code{\link{set_queue_attrs}}
}
%\examples{}
