\name{sqsHTTP}
\alias{sqsHTTP}
\title{Execute SQS API Request}
\description{This is the workhorse function to execute calls to the SQS API.}
\usage{
sqsHTTP(url = NULL, query = list(), 
        region = Sys.getenv("AWS_DEFAULT_REGION", "us-east-1"), 
        key = Sys.getenv("AWS_ACCESS_KEY_ID"), 
        secret = Sys.getenv("AWS_SECRET_ACCESS_KEY"), 
        ...)
}
\arguments{
  \item{url}{A character string containing an SQS API endpoint URL.}
  \item{query}{An optional named list containing query string parameters and their character values.}
  \item{region}{A character string containing an AWS region. If missing, the default \dQuote{us-east-1} is used.}
  \item{key}{A character string containing an AWS Access Key ID. The default is pulled from environment variable \dQuote{AWS_ACCESS_KEY_ID}.}
  \item{secret}{A character string containing an AWS Secret Access Key. The default is pulled from environment variable \dQuote{AWS_SECRET_ACCESS_KEY}.}
  \item{...}{Additional arguments passed to \code{\link[httr]{GET}}.}
}
\details{This function constructs and signs an SQS API request and returns the results thereof, or relevant debugging information in the case of error.}
\value{If successful, a named list. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.}
%\references{}
\author{Thomas J. Leeper}
%\note{}
%\seealso{}
%\examples{}
