output "snsRoleArn" {
  description = "The sns role which sns assumes when publishing to kinesis firehose"
  value = aws_iam_role.sns_to_firehose_role.arn
}

output "kinesisFireHoseDeliveryStreamArn" {
  description = "The arn to the kinesis firehose delivery stream"
  value = aws_kinesis_firehose_delivery_stream.kinesis_delivery_stream.arn
}