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
Creates a topic and gives the external subscribers permission to create topic subscriptions to this topic