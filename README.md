# terraform-aws-trafficcontrol
Collection of terraform modules created by Team Traffic Control

To use a module in your terraform code include the following:

```
module "local-module-name" {
  source = "github.com/nsbno/terraform-aws-trafficcontrol?ref=<commit-ref>/<module-name>"

  .....
}
```

# Modules
## sns-topic-subscription
Takes a sqs queue name, tags, and the fully qualified sns topic name to which you want to subscribe, and creates the queue with 
a topic subscription to the given topic. Adds iam policy to allow sns to send messages to the queue.

Json encoded filter_policy for the subscription is optional.

Returns the arn, id and name of the newly create sqs queue.

## rds-provisioning
Creates a database and role in the given RDS instance from the parameters: database name, username.
The RDS instance identifier specifies which RDS instance the resources should be created in.

#### Prerequisites
This module requires the following to be available in the AWS context:
* An RDS instance with the identifier: `{rds_instance_id}`
* A lambda function with name `{name_prefix}-rds-provisioning` used to access the RDS instance.
* An SSM parameter with name `{rds_instance_id}-rds-master-password` containing the master password of the RDS instance. 

## sns-topic
Creates a topic and gives the external subscribers permission to create topic subscriptions to this topic.
Can also be configured to log all published messages to s3 via kinesis firehose.

## sns-to-s3-firehose
Module that creates a kinesis firehose delivery stream, and sets up a sns role for sns so it can be used to publish
all messages to this stream which then saves all messages to s3 and makes them ready for querying in Athena using a 
glue crawler and table.
Crawler is set ut to run every 3 hours, and s3 bucket used for storing published messages have a bucket retetion period
of 30 days.

## sns-firehose-subscription
Module for enabling logging av all published messages to s3 via firehose.
Requires an iam role for sns and a firehose delivery stream.

## sqs-queue
Creates an sqs queue with support for enabling a dead letter queue.

## oidc-role
Creates an iam-role with policies using a configured OIDC provider to authenticate with OIDC.