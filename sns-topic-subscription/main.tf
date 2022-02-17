module "sqs_queue" {
  source = "../sqs-queue"
  queue_name = var.queue_name
  delay_seconds = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  fifo_queue                 = var.fifo_queue
  tags                       = var.tags
  enable_dlq = var.enable_dlq
}

resource "aws_sns_topic_subscription" "topic_subscription" {
  endpoint             = module.sqs_queue.sqs_queue_arn
  protocol             = "sqs"
  raw_message_delivery = true
  topic_arn            = var.sns_topic_arn
  filter_policy        = length(var.filter_policy) > 0 ? var.filter_policy : null
}

data "aws_iam_policy_document" "iam_policy_document" {
  statement {
    effect = "Allow"
    principals {
      identifiers = [
        "sns.amazonaws.com"
      ]
      type = "Service"
    }
    actions = [
      "SQS:SendMessage"
    ]
    resources = [
      module.sqs_queue.sqs_queue_arn
    ]
  }
}

resource "aws_sqs_queue_policy" "sqs_queue_policy" {
  policy    = data.aws_iam_policy_document.iam_policy_document.json
  queue_url = module.sqs_queue.sqs_queue_id
}
