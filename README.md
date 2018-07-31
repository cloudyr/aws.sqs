# AWS SQS Client Package

**aws.sqs** is a simple client package for the Amazon Web Services (AWS) [Simple Queue Service (SQS)](http://aws.amazon.com/sqs/) API, which is a message queuing service that can be used to facilitate communication between cloud and/or local applications. Possible use cases include:

 - Logging error messages to process later
 - Receiving messages from other AWS services (e.g., Simple Notification Service, Mechanical Turk, etc.)
 - Piping output from one application into the input of another application without requiring a persistent connection

To use the package, you will need an AWS account and to enter your credentials into R. Your keypair can be generated on the [IAM Management Console](https://aws.amazon.com/) under the heading *Access Keys*. Note that you only have access to your secret key once. After it is generated, you need to save it in a secure location. New keypairs can be generated at any time if yours has been lost, stolen, or forgotten. The [**aws.iam** package](https://github.com/cloudyr/aws.iam) profiles tools for working with IAM, including creating roles, users, groups, and credentials programmatically; it is not needed to *use* IAM credentials.

A detailed description of how credentials can be specified is provided at: https://github.com/cloudyr/aws.signature/. The easiest way is to simply set environment variables on the command line prior to starting R or via an `Renviron.site` or `.Renviron` file, which are used to set environment variables in R during startup (see `? Startup`). They can be also set within R:

```R
Sys.setenv("AWS_ACCESS_KEY_ID" = "mykey",
           "AWS_SECRET_ACCESS_KEY" = "mysecretkey",
           "AWS_DEFAULT_REGION" = "us-east-1",
           "AWS_SESSION_TOKEN" = "mytoken")
```

## Code Examples

To use SQS, you need to start by creating a queue, which is a store of messages that you would like to make available to users or applications:


```r
library("aws.sqs")
queue <- create_queue("ExampleQueue")
```

`create_queue()` will create an SQS queue and return a character string containing the queue URL. You will need to use this URL in subsequent function calls in order to perform actions on a queue. Because the URL is long and not particularly memorable, **aws.sqs** implements a further convenience that allows you to pass a queue name (in this case "ExampleQueue") instead of the full URL. If you need the URL for some other reason (for example, to configure the queue in another application), you can retrieve it using `get_queue_url()`:


```r
get_queue_url("ExampleQueue")
```

```
## [1] "https://sqs.us-east-1.amazonaws.com/920667304251/ExampleQueue"
## attr(,"RequestId")
## [1] "a22e2266-d94a-5abe-80cc-73b6a87fb31f"
```

Once a URL is created, it will show up in the list of queues:


```r
list_queues()
```

```
## [1] "https://sqs.us-east-1.amazonaws.com/920667304251/ExampleQueue"
## [2] "https://sqs.us-east-1.amazonaws.com/920667304251/MTurkR"      
## [3] "https://sqs.us-east-1.amazonaws.com/920667304251/TestQueue"   
## attr(,"RequestId")
## [1] "4ee16392-bc14-5bf3-bf27-3242cd226252"
```

And you can begin performing operations on the queue. The most important of these are `send_msg()` (to put a message into the queue), `receive_msg()` (to retrieve one or more messages from the queue), and `delete_msg()` (to delete a message once it is no longer needed in the queue).


```r
send_msg("ExampleQueue", "This is a test message")
```

```
## [[1]]
## [[1]]$MD5OfMessageAttributes
## NULL
## 
## [[1]]$MD5OfMessageBody
## [1] "fafb00f5732ab283681e124bf8747ed1"
## 
## [[1]]$MessageId
## [1] "8f56363a-afb5-44d5-ae90-37a2ebe7d78f"
## 
## [[1]]$SequenceNumber
## NULL
## 
## 
## attr(,"RequestId")
## [1] "266990f9-dc4f-5fac-b384-c129ad79660d"
```

The `send_msg()` function is also vectorized, so that you can send multiple messages in the same call simply by specifying a vector of message bodies. Note: The `send_msg()` function will return some (mostly useless) details of the message, namely the MD5 sum of the message body. Perhaps this could be used to confirm that SQS has received and entered the message into the queue correctly.

The flip side of `send_msg()` is `receive_msg()`, which pulls one or more messages (if there are any) from the queue. Once received, the message(s) are no longer available to any other `receive_msg()` request for a specified "visibility timeout" period. This period is specified, by default, in the queue attributes and can be modified atomically for the particular messages being retrieved in this call to `receive_msg()`. Note how two back-to-back `receive_msg()` calls behave with and without a `timeout` argument:


```r
# With specified timeout
(m <- receive_msg("ExampleQueue", timeout = 0)) # msg visible, does not mask msg for next call
```

```
##   Attributes                   Body                        MD5OfBody
## 1         NA This is a test message fafb00f5732ab283681e124bf8747ed1
##   MD5OfMessageAttributes MessageAttributes
## 1                     NA                NA
##                              MessageId
## 1 8f56363a-afb5-44d5-ae90-37a2ebe7d78f
##                                                                                                                                                                                                                                                                                                                                                                                          ReceiptHandle
## 1 AQEBlJDH5q5K912m3kinrOoa4fiEgRjR24Qp0nIX1MsKnlp6RPZPABob/sqo4cK4PG6Z3G1zDCJmu8fjhwpY3wG8+nqSh9H2Nv4mfuGG/kjBaklKnmeGg5AT6EHHwxkP0Hq8nQgqvGWzZEeWlpeb/Smld5ijRw6Ns/C4ynjsZYkA/EyQ4SN2nDczzGHsPsMMLii2nn6PiVKZSBMAJ6hOJX0XRiAyqtS1j4D42duJwVfKo4jY27OcvB4DSfSjkeYYxlNL07qICUK9rqdZBm7lKV+7+HY3J75mm+mtk8eaHUP4OlWQpgV3kT0m+LDt9i4RQz+7lGKZC8Jmk24DSbOh1FK1ctFfeBGmT1361lFh7vUP/IO0LGqz6lBgT7hMmBRYPGqQ
```

```r
Sys.sleep(.5)
receive_msg("ExampleQueue", timeout = 0) # msg still visible, does not mask msg for next call
```

```
##   Attributes                   Body                        MD5OfBody
## 1         NA This is a test message fafb00f5732ab283681e124bf8747ed1
##   MD5OfMessageAttributes MessageAttributes
## 1                     NA                NA
##                              MessageId
## 1 8f56363a-afb5-44d5-ae90-37a2ebe7d78f
##                                                                                                                                                                                                                                                                                                                                                                                          ReceiptHandle
## 1 AQEBnY5W+8UrtMvzJe1RXjL5IZAJ8/+b9lqZ2da/3xfmDrg3ExU9i3mg8ey3Eo0XJ9aFC0u710aZ8i6JumRjiY05GkQ9dXHttfAL2EOC6vIi4v5WSoBj/sq6vUjdyDHEyf8545QfgN1wt+SmcWVH6SDHA8wc81XA6yLwFmxFqROUw3yq0d2BWFHzXePTTMlMaufSVODursYT3te9vc8RmIsC5cLUG7mwf0tNzHWo/lNYqWCLto4+JQB7MHNhO3OHDlLoEtWTLXuu+AqcaF2jVjYHb1r6x2r8givBQ0h37OtuYwhtQ2DXJqLPQG8R/5+DHehgy4V0rYqNelxcfGa7g2WAakApQMi8r6wFFSC7oewuqP5uKGLT7syF+40JGtQmMUlB
```

```r
# No specified timeout (uses queue default; 30 seconds)
receive_msg("ExampleQueue") # msg still visible, masks msg for next call
```

```
##   Attributes                   Body                        MD5OfBody
## 1         NA This is a test message fafb00f5732ab283681e124bf8747ed1
##   MD5OfMessageAttributes MessageAttributes
## 1                     NA                NA
##                              MessageId
## 1 8f56363a-afb5-44d5-ae90-37a2ebe7d78f
##                                                                                                                                                                                                                                                                                                                                                                                          ReceiptHandle
## 1 AQEBQWuh8Tl3BhQqj5RC+v/sknHrlvHDOe6qndf+KmGrGoM04v755AfkH2Qx0LO5k8kLo9FMbgiyvXMarJ2ezMHx/AENa1yBImi3ruaeUsyA0vXtFcuQ9yrOT+EtDdaVJY8DH0CZg8lPmc8nsDyM+DZC2hK3BwpqdR3D31KXyTr7jK+w36vw0lWLqzGZpO71TbLwjjQiaipKdAD//F8k1Q/NDyUq7IEmHQLZRA2UPhMHPgAzasbGj9VdtWL4LIsaXPlhw4nEyrYmg5JZSXjQxHXKvikAoeOTWu3NnrKJjZoqD1SlSuc/6M5qZ8WdmwpKox/7L/Z+bTThRWkL7qLs5fLyTnfbFHTTySL6qKkePGJMBHSgjcDQehN5CzW48FJfXQIH
```

```r
Sys.sleep(.5)
receive_msg("ExampleQueue") # msg not visible, msg masked by last call
```

```
## [1] Attributes             Body                   MD5OfBody             
## [4] MD5OfMessageAttributes MessageAttributes      MessageId             
## [7] ReceiptHandle         
## <0 rows> (or 0-length row.names)
```

By default, once the "visibility timeout" expires, the message becomes available to future polling requests by `receive_msg()`. The function also supports "long polling," which allows your application to wait for a longer period of time for new messages to arrive in the queue. This minimizes the number of API calls that are needed to retrieve messages that arrive in the queue somewhat slowly.


```r
receive_msg("ExampleQueue", timeout = 5)
```

```
## [1] Attributes             Body                   MD5OfBody             
## [4] MD5OfMessageAttributes MessageAttributes      MessageId             
## [7] ReceiptHandle         
## <0 rows> (or 0-length row.names)
```

```r
receive_msg("ExampleQueue")
```

```
## [1] Attributes             Body                   MD5OfBody             
## [4] MD5OfMessageAttributes MessageAttributes      MessageId             
## [7] ReceiptHandle         
## <0 rows> (or 0-length row.names)
```

```r
receive_msg("ExampleQueue", wait = 5)
```

```
## [1] Attributes             Body                   MD5OfBody             
## [4] MD5OfMessageAttributes MessageAttributes      MessageId             
## [7] ReceiptHandle         
## <0 rows> (or 0-length row.names)
```

It is also possible to change the visibility of a message after it has been received. This can be useful if message processing is taking longer than the visibility timeout window. The `visibility()` function takes a queue name (or URL), message handle, and an amount to extend the timeout in seconds.


```r
visibility("ExampleQueue", m$ReceiptHandle, timeout = 30)
```

```
## [1] TRUE
## attr(,"RequestId")
## [1] "92d36ef8-3916-5d67-a391-3f284829a4c6"
```

Two important notes are worth highlighting here. First, a queue can only have a maximum timeout of 12 hours, but `visibility()` is not aware of how long the current visibility is (and that amount of time is not retrievable via the API), so you need to be cautious in extending the visibility timeout beyond the maximum by respecting the queue's default timeout and accommodating any modifications of that made when polling for new messages. Second, the function is vectorized to allow visibility timeout extensions, of potentially different amounts of time, for multiple messages from the same queue.

If you are finished with a message entirely (e.g., your application has processed the message and the task associated with the message is completed), you should delete the message using the queue name (or URL) and the *ReceiptHandle* for the message as returned by `receive_msg()`:


```r
delete_msg("ExampleQueue", m$ReceiptHandle[1])
```

```
## [1] TRUE
## attr(,"RequestId")
## [1] "e7347f29-1bba-531d-b12f-2ef96a858abc"
```

`delete_msg()` will accept a vector of ReceiptHandle values from the same queue to perform a bulk delete. If you're done with all messages in a queue, you can remove them all using, e.g., `purge_queue("TestQueue")`. If you're done with a queue entirely, you can delete it:


```r
delete_queue("ExampleQueue")
```

```
## [1] TRUE
## attr(,"RequestId")
## [1] "5ce460e0-f289-5a73-9bcb-313083c903d2"
```

## Installation

[![CRAN](https://www.r-pkg.org/badges/version/aws.sqs)](https://cran.r-project.org/package=aws.sqs)
![Downloads](https://cranlogs.r-pkg.org/badges/aws.sqs)
[![Build Status](https://travis-ci.org/cloudyr/aws.sqs.png?branch=master)](https://travis-ci.org/cloudyr/aws.sqs)
[![codecov.io](https://codecov.io/github/cloudyr/aws.sqs/coverage.svg?branch=master)](https://codecov.io/github/cloudyr/aws.sqs?branch=master)

This package is not yet on CRAN. To install the latest development version you can install from the cloudyr drat repository:

```R
# latest stable version
install.packages("aws.sqs", repos = c(getOption("repos"), "http://cloudyr.github.io/drat"))
```

Or, to pull a potentially unstable version directly from GitHub:

```R
if(!require("remotes")){
    install.packages("remotes")
}
remotes::install_github("cloudyr/aws.sqs")
```

---
[![cloudyr project logo](http://i.imgur.com/JHS98Y7.png)](https://github.com/cloudyr)
