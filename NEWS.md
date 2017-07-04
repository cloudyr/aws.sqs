# CHANGES TO aws.sqs 0.1.10

* Change functions `add_permission` and `remove_permission` to `add_queue_permission` and `remove_queue_permission` to avoid namespace clash with **aws.sns** in **awspack**.

# CHANGES TO aws.sqs 0.1.7

* Update docs and knit README for CRAN release.

# CHANGES TO aws.sqs 0.1.7

* Added a convenience function, `consume_msg()`, that simply calls `receive_msg()` and `delete_msg()` in sequence. (#5)
* Added a `query` argument to all functions in order to pass optional arguments to `sqsHTTP()`. (#7, h/t Ludovic Vannoorenberghe)

# CHANGES TO aws.sqs 0.1.6

* Fixed a typo in `get_queue_attrs()` that was preventing return of attributes. (h/t Dinesh Mistry)

# CHANGES TO aws.sqs 0.1.4

* Fixed a bug in `delete_msg()` that was preventing message deletion. (#4)

# CHANGES TO aws.sqs 0.1.2

* Fixed a `structure()` bug in `sqsHTTP()` that was reporting an error when JSON parsing failed. (#4)
* Documented `add_permission()` and `remove_permission()`.

# CHANGES TO aws.sqs 0.1.1

* Initial release.
