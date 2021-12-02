data "aws_sns_topic" "topic" {
  name = var.topic_name
}

resource "aws_sqs_queue" "sqs_queue" {
  name                       = var.queue_name
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 20
  visibility_timeout_seconds = 60
  fifo_queue                 = false
  tags                       = var.tags
}

resource "aws_sns_topic_subscription" "topic_subscription" {
  endpoint             = aws_sqs_queue.sqs_queue.arn
  protocol             = "sqs"
  raw_message_delivery = true
  topic_arn            = data.aws_sns_topic.topic.arn
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
      aws_sqs_queue.sqs_queue.arn
    ]
  }
}

resource "aws_sqs_queue_policy" "sqs_queue_policy" {
  policy = data.aws_iam_policy_document.iam_policy_document.json
  queue_url = aws_sqs_queue.sqs_queue.id
}
