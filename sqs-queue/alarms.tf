############################################################################################
# Configure Default Cloudwatch Alarms for DLQ
############################################################################################
resource "aws_cloudwatch_metric_alarm" "dlq_unhealty" {
  count               = var.enable_dlq_alarm ? 1 : 0
  metric_name         = "ApproximateNumberOfMessagesVisible"
  alarm_name          = "${aws_sqs_queue.sqs_queue_dlq[0].name}_unhealty"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  namespace           = "AWS/SQS"
  dimensions = {
    QueueName = aws_sqs_queue.sqs_queue_dlq[0].name
  }
  period            = 60
  statistic         = "Sum"
  alarm_description = "${aws_sqs_queue.sqs_queue_dlq[0].name} contains unprocessed messages"
  tags              = var.tags
  alarm_actions     = [var.alarm_topic_arn]
  ok_actions        = [var.alarm_topic_arn]
}