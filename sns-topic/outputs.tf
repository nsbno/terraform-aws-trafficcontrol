output "topicArn" {
  description = "The Amazon SNS arn created in this module"
  value = aws_sns_topic.sns_topic.arn
}

output "topicId" {
  description = "The Amazon SNS Id created in this module"
  value = aws_sns_topic.sns_topic.id
}

output "bucketId" {
  description = "The S3-bucket ID created in this module."
  value = aws_s3_bucket.large_message_payload[*].id
}

output "bucketArn" {
  description = "The S3-bucket ARN created in this module."
  value = aws_s3_bucket.large_message_payload[*].arn
}