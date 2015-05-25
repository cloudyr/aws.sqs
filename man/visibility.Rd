\name{visibility}
\alias{visibility}
\title{Change Visiblity Timeout}
\description{Change the visibility timeout of received message(s)}
\usage{
visibility(queue, handle, timeout = NULL, ...)
}
\arguments{
  \item{queue}{A character string containing a queue URL, or the name of the queue.}
  \item{handle}{A character vector containing one or more message handles, as returned by \code{\link{receive_msg}}.}
  \item{timeout}{An integer value indicating the new value of the visibility timeout, in seconds between 0 and 43200, for the message(s).}
  \item{...}{Additional arguments passed to \code{\link{sqsHTTP}}.}
}
\details{Changes the visibility timeout of one or more SQS messages, by their message handle.}
\value{If successful, a logical \code{TRUE}. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.}
\references{\href{http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_ChangeMessageVisibility.html}{ChangeMessageVisibility}}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{link{receive_msg}}
\code{link{delete_msg}}
}
%\examples{}
