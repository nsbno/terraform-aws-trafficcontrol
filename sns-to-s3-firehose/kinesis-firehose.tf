### Kinesis firehose delivery stream
# Use extended s3 configuration
resource "aws_kinesis_firehose_delivery_stream" "kinesis_delivery_stream" {
  name        = "${var.name_prefix}-sns-to-s3-delivery-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    bucket_arn = aws_s3_bucket.s3_kinesis.arn
    role_arn   = aws_iam_role.kinesis_firehose_stream_role.arn
  }
  tags = var.tags
}