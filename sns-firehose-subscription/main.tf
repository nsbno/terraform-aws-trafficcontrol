data "aws_kinesis_firehose_delivery_stream" "firehose_delivery_stream" {
  name = var.kinesis_firehose_delivery_stream_name
}

data "aws_iam_role" "sns_to_kinesis_role" {
  name = var.sns_to_kinesis_role_name
}

resource "aws_sns_topic_subscription" "firehose_topic_subscription" {
  endpoint              = data.aws_kinesis_firehose_delivery_stream.firehose_delivery_stream.arn
  protocol              = "firehose"
  subscription_role_arn = data.aws_iam_role.sns_to_kinesis_role.arn
  topic_arn             = var.sns_topic_arn
}