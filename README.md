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