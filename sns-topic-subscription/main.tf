
resource "aws_sqs_queue" "sqs_queue" {
  name                       = var.queue_name
  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  fifo_queue                 = var.fifo_queue
  tags                       = var.tags
  redrive_policy = var.enable_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sqs_queue_dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null
}

resource "aws_sqs_queue" "sqs_queue_dlq" {
  count                      = var.enable_dlq ? 1 : 0
  name                       = "${var.queue_name}-DLQ"
  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  fifo_queue                 = var.fifo_queue
  message_retention_seconds  = var.message_retention_seconds * 10
  tags                       = var.tags
}


resource "aws_sns_topic_subscription" "topic_subscription" {
  endpoint             = aws_sqs_queue.sqs_queue.arn
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
      aws_sqs_queue.sqs_queue.arn
    ]
  }
}

resource "aws_sqs_queue_policy" "sqs_queue_policy" {
  policy    = data.aws_iam_policy_document.iam_policy_document.json
  queue_url = aws_sqs_queue.sqs_queue.id
}
