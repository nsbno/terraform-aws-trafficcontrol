# Set up a sns topic for external subscribers
resource "aws_sns_topic" "sns_topic" {
  name = var.name
  tags = var.tags
}

resource "aws_sns_topic_policy" "sns_topic_policy" {
  count = length(var.external_subscribers) > 0 ? 1 : 0
  arn = aws_sns_topic.sns_topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    sid = "default_policy_id"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values = [
        var.current_account,
      ]
    }
    resources = [aws_sns_topic.sns_topic.arn]
  }

  statement {
    sid = "cross_account_policy_id"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = formatlist("arn:aws:iam::%s:root", var.external_subscribers)
    }
    actions = [
      "SNS:Subscribe"
    ]
    resources = [aws_sns_topic.sns_topic.arn]
  }
}

resource "aws_s3_bucket" "large_message_payload" {
  count = var.create_payload_bucket == true ? 1 : 0
  bucket = var.payload_bucket_name
}

resource "aws_s3_bucket_policy" "allow_external_read" {
  count = var.create_payload_bucket && length(var.external_subscribers) > 0 ? 1 : 0
  bucket = aws_s3_bucket.large_message_payload[0].id
  policy = data.aws_iam_policy_document.allow_external_read.json
}

data "aws_iam_policy_document" "allow_external_read" {
  statement {
    principals {
      type        = "AWS"
      identifiers = var.external_subscribers
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.large_message_payload[0].arn,
      "${aws_s3_bucket.large_message_payload[0].arn}/*",
    ]
  }
}