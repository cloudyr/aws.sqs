# AWS SQS Client Package

**aws.sqs** is a simple client package for the Amazon Web Services (AWS) [Simple Queue Service (SQS)](http://aws.amazon.com/sqs/) API, which is a message queuing service that can be used to facilitate communication between cloud and/or local applications. Possible use cases include:

 - Logging error messages to process later
 - Receiving messages from other AWS services (e.g., Simple Notification Service, Mechanical Turk, etc.)
 - Piping output from one application into the input of another application without requiring a persistent connection

To use the package, you will need an AWS account and enter your credentials into R. Your keypair can be generated on the [IAM Management Console](https://aws.amazon.com/) under the heading *Access Keys*. Note that you only have access to your secret key once. After it is generated, you need to save it in a secure location. New keypairs can be generated at any time if yours has been lost, stolen, or forgotten. 

By default, all **cloudyr** packages look for the access key ID and secret access key in environment variables. You can also use this to specify a default region or a temporary "session token". For example:

```R
Sys.setenv("AWS_ACCESS_KEY_ID" = "mykey",
           "AWS_SECRET_ACCESS_KEY" = "mysecretkey",
           "AWS_DEFAULT_REGION" = "us-east-1",
           "AWS_SESSION_TOKEN" = "mytoken")
```

These can alternatively be set on the command line prior to starting R or via an `Renviron.site` or `.Renviron` file, which are used to set environment variables in R during startup (see `? Startup`).

If you work with multiple AWS accounts, another option that is consistent with other Amazon SDKs is to create [a centralized `~/.aws/credentials` file](https://blogs.aws.amazon.com/security/post/Tx3D6U6WSFGOK2H/A-New-and-Standardized-Way-to-Manage-Credentials-in-the-AWS-SDKs), containing credentials for multiple accounts. You can then use credentials from this file on-the-fly by simply doing:

```R
# use your 'default' account credentials
use_credentials()

# use an alternative credentials profile
use_credentials(profile = "bob")
```

Temporary session tokens are stored in environment variable `AWS_SESSION_TOKEN` (and will be stored there by the `use_credentials()` function). The [aws.iam package](https://github.com/cloudyr/aws.iam/) provides an R interface to IAM roles and the generation of temporary session tokens via the security token service (STS).

## Code Examples

To use SQS, you need to start by creating a queue, which is a store of messages that you would like to make available to users or applications:


```r
library("aws.sqs")
queue <- create_queue("ExampleQueue")
```

`create_queue` will create an SQS queue and return a character string containing the queue URL. You will need to use this URL in subsequent function calls in order to perform actions on a queue. Because the URL is long and not particularly memorable, **aws.sqs** implements a further convenience that allows you to pass a queue name (in this case "ExampleQueue") instead of the full URL. If you need the URL for some other reason (for example, to configure the queue in another application), you can retrieve it using `get_queue_url`:


```r
get_queue_url("ExampleQueue")
```

```
## [1] "https://sqs.us-east-1.amazonaws.com/920667304251/ExampleQueue"
## attr(,"RequestId")
## [1] "cc49b334-02f9-531e-ae87-e3f08342f58d"
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
## [1] "b2171765-9a87-5339-ac1c-47a11b3c55aa"
```

And you can begin performing operations on the queue. The most important of these are `send_msg` (to put a message into the queue), `receive_msg` (to retrieve one or more messages from the queue), and `delete_msg` (to delete a message once it is no longer needed in the queue).


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
## [1] "84732998-7628-4069-911a-0bfb4490534e"
## 
## 
## attr(,"RequestId")
## [1] "b11e8c6b-a69a-5c24-acae-dcaf27213ab7"
```

The `send_msg` function is also vectorized, so that you can send multiple messages in the same call simply by specifying a vector of message bodies. Note: The `send_msg` function will return some (mostly useless) details of the message, namely the MD5 sum of the message body. Perhaps this could be used to confirm that SQS has received and entered the message into the queue correctly.

The flip side of `send_msg` is `receive_msg`, which pulls one or more messages (if there are any) from the queue. Once received, the message(s) are no longer available to any other `receive_msg` request for a specified "visibility timeout" period. This period is specified, by default, in the queue attributes and can be modified atomically for the particular messages being retrieved in this call to `receive_msg`. Note how two back-to-back `receive_msg` calls behave with and without a `timeout` argument:


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
## 1 84732998-7628-4069-911a-0bfb4490534e
##                                                                                                                                                                                                                                                                                                                                                                                          ReceiptHandle
## 1 AQEBatoaNvHqR30dC49zvcf2BprIBAx672ZFCNGUaIg0VBBvylnOMT7qw5HPJXczSxjNJBk4usW/NmEW3z8Hy8a4Iyhn9lzEqJPgzCBP/yBjlx3ymGp0goJQc3DiJkBA+g84xYhx/2l24XtqUTzzeSgc8Y4W+qAVIhJxZlZhz8y8kQVLjHWMJ1St8RtmgMn4bSAzL+L/iMERFMUryDeReOjEKXGQfIgnJqP45k/lXS3oivckqJaME+ZUtB4gCSpaEjmxDJHk6NZCBVH/bdnRJXIrZRDY0B3WHUm6TZq4e+iUZnYRwDVY38td88b4qu3BD+6/4uDzrD51VJsZRv32WCMPl5cWl/A8PylN423u60VVMRcYXzhLopWXgLwSFn/Fk6PP
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
## 1 84732998-7628-4069-911a-0bfb4490534e
##                                                                                                                                                                                                                                                                                                                                                                                          ReceiptHandle
## 1 AQEBCsksCGbvSCS+spxIXW02B+9KJSAr6zdJ0RJgL6kIb7yIvyyNAC/gnQ9GRQEnwo0Wmf/Xe9z2qYfTcnp3lJfPThHVT85iKnxPWkj5/m+E+8djNlqST9XUMRccZElgh/udmP4vBAKMxyeTpm54eQf8TXGmhSubEnz/Uqq28nsdbFIl0sbKc6nsBvboDI/chVFTrOwlXcGabg3xsto5+9l9A/TSDTnAvpFUGCuLz4RksXBOw1dtSvHcJFdIvvaRj4K5yYgrhCZeMC7wTJW0TcwgouMDoYLhoZEOPiiVoUd//0GQ2/8BgA//iydUHGOLWrH+Qzfr5gZt59VMdA8EBFPJXwH+Ofhxp628XOn6o5Qf6oNF3GgptsZT+bTbjxpVacc9
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
## 1 84732998-7628-4069-911a-0bfb4490534e
##                                                                                                                                                                                                                                                                                                                                                                                          ReceiptHandle
## 1 AQEBHjnPv98hrDW/lBmn5949xGa1y+Y91fhYBkTjI8PNcY9CeHcmtyJCk753RdlzCW8OwG0Pr6xT52bVbbHDBHK4vos43wQxlMkwcOZWVux/4nT9mB7EhejHF1C6J3IMHSPdyYmKtIHP+kD2uyBOJ0JVT7molwFOb4+ZjkPTkNDyc9uM1QiDSaYsho3IbabUtaMupBwy3vv5Za8ccvb9KJQM2WZ6Gbxhc3W2GyklTV8g0+5pNC2OGzbHCfSB/sXu6UCm9NxxcsULs3bEtOVXR7XFR5we1pXPo+8y5nV/SE77pSIGChWFu7/zwVb57/kK3fp2o4gg1pv/ODPHqEE0iVa5P/ngxsKu3NCTt5A4Dij5nh1O9c/D7iZzS48r45Dl+xsK
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

By default, once the "visibility timeout" expires, the message becomes available to future polling requests by `receive_msg`. The function also supports "long polling," which allows your application to wait for a longer period of time for new messages to arrive in the queue. This minimizes the number of API calls that are needed to retrieve messages that arrive in the queue somewhat slowly.


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

It is also possible to change the visibility of a message after it has been received. This can be useful if message processing is taking longer than the visibility timeout window. The `visibility` function takes a queue name (or URL), message handle, and an amount to extend the timeout in seconds.


```r
visibility("ExampleQueue", m$ReceiptHandle, timeout = 30)
```

```
## [1] TRUE
## attr(,"RequestId")
## [1] "b8e7b69e-a450-55f4-ba6e-e65a25947367"
```

Two important notes are worth highlighting here. First, a queue can only have a maximum timeout of 12 hours, but `visibility` is not aware of how long the current visibility is (and that amount of time is not retrievable via the API), so you need to be cautious in extending the visibility timeout beyond the maximum by respecting the queue's default timeout and accommodating any modifications of that made when polling for new messages. Second, the function is vectorized to allow visibility timeout extensions, of potentially different amounts of time, for multiple messages from the same queue.

If you are finished with a message entirely (e.g., your application has processed the message and the task associated with the message is completed), you should delete the message using the queue name (or URL) and the *ReceiptHandle* for the message as returned by `receive_msg`:


```r
delete_msg("ExampleQueue", m$ReceiptHandle[1])
```

```
## [1] TRUE
## attr(,"RequestId")
## [1] "84ec20aa-8d88-5456-81b9-706e0c4ca2c5"
```

`delete_msg` will accept a vector of ReceiptHandle values from the same queue to perform a bulk delete. If you're done with all messages in a queue, you can remove them all using, e.g., `purge_queue("TestQueue")`. If you're done with a queue entirely, you can delete it:


```r
delete_queue("ExampleQueue")
```

```
## [1] TRUE
## attr(,"RequestId")
## [1] "817cd720-a057-56cb-b712-87e42193d058"
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
if(!require("ghit")){
    install.packages("ghit")
}
ghit::install_github("cloudyr/aws.sqs")
```

---
[![cloudyr project logo](http://i.imgur.com/JHS98Y7.png)](https://github.com/cloudyr)
