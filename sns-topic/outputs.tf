output "topicArn" {
  description = "The Amazon SNS arn created in this module"
  value = aws_sns_topic.sns_topic.arn
}

output "topicId" {
  description = "The Amazon SNS Id created in this module"
  value = aws_sns_topic.sns_topic.id
}