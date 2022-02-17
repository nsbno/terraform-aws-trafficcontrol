output "sqs_queue_arn" {
  description = "The Amazon SQS arn created in this module"
  value       = aws_sqs_queue.sqs_queue.arn
}

output "sqs_queue_id" {
  description = "The Amazon SQS id created in this module"
  value       = aws_sqs_queue.sqs_queue.id
}

output "sqs_queue_name" {
  description = "The Amazon SQS name created in this module"
  value       = aws_sqs_queue.sqs_queue.name
}