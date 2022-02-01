# Set up a sns topic for external subscribers
resource "aws_sns_topic" "sns_topic" {
  name = var.name
  tags = var.tags
}

resource "aws_sns_topic_policy" "sns_topic_policy" {
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