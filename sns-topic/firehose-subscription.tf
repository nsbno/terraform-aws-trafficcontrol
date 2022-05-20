data "aws_kinesis_firehose_delivery_stream" "firehose_delivery_stream" {
  count  = var.enable_logging_of_published_messages ? 1 : 0
  name = var.kinesis_firehose_delivery_stream_name
}

data "aws_iam_role" "sns_to_kinesis_role" {
  count  = var.enable_logging_of_published_messages ? 1 : 0
  name = var.sns_to_kinesis_role_name
}

resource "aws_sns_topic_subscription" "firehose_topic_subscription" {
  count  = var.enable_logging_of_published_messages ? 1 : 0
  endpoint  = data.aws_kinesis_firehose_delivery_stream.firehose_delivery_stream.arn
  protocol  = "firehose"
  subscription_role_arn = var.sns_to_kinesis_role_name.arn
  topic_arn = aws_sns_topic.sns_topic.arn
}