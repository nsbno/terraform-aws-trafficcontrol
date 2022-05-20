### IAM policies for the kinesis firehose delivery stream
# Policy to allow firehose to assume a role
data "aws_iam_policy_document" "kinesis_firehose_stream_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

# Policy to allow kinesis access to the s3 bucket where it will store the content of the delivery stream
data "aws_iam_policy_document" "kinesis_firehose_access_bucket_assume_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.s3_kinesis.arn,
      "${aws_s3_bucket.s3_kinesis.arn}/*",
    ]
  }
}

# Allow kinesis firehose to access table versions in glue
data "aws_iam_policy_document" "kinesis_firehose_access_glue_assume_policy" {
  statement {
    effect    = "Allow"
    actions   = ["glue:GetTableVersions"]
    resources = ["*"]
  }
}

# IAM role for kinesis firehose delivery stream
resource "aws_iam_role" "kinesis_firehose_stream_role" {
  name               = "${var.name_prefix}-kinesis_firehose_stream_role"
  assume_role_policy = data.aws_iam_policy_document.kinesis_firehose_stream_assume_role.json
  tags               = var.tags
}

# Attach role policy to allow kinesis firehose to access s3bucket
resource "aws_iam_role_policy" "kinesis_firehose_access_bucket_policy" {
  name   = "${var.name_prefix}-kinesis_firehose_access_bucket_policy"
  role   = aws_iam_role.kinesis_firehose_stream_role.name
  policy = data.aws_iam_policy_document.kinesis_firehose_access_bucket_assume_policy.json
}

# Attach role policy to allow kinesis firehose to access glue table
resource "aws_iam_role_policy" "kinesis_firehose_access_glue_policy" {
  name   = "${var.name_prefix}-kinesis_firehose_access_glue_policy"
  role   = aws_iam_role.kinesis_firehose_stream_role.name
  policy = data.aws_iam_policy_document.kinesis_firehose_access_glue_assume_policy.json
}


### IAM policies for sns
# Policy to allow sns to assume a role
data "aws_iam_policy_document" "sns_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
  }
}

# Policy to allow sns to publish messages to kinesis firehose and confirm subscriptions
data "aws_iam_policy_document" "sns_to_firehose_role_assume_policy" {
  statement {
    effect  = "Allow"
    actions = [
      "firehose:DescribeDeliveryStream",
      "firehose:ListDeliveryStreams",
      "firehose:ListTagsForDeliveryStream",
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]
    resources = [aws_kinesis_firehose_delivery_stream.kinesis_delivery_stream.arn]
  }
}
# IAM role for sns with policy to assume role
resource "aws_iam_role" "sns_to_firehose_role" {
  name               = "${var.name_prefix}-sns_to_firehose_role"
  assume_role_policy = data.aws_iam_policy_document.sns_assume_role.json
  tags               = var.tags
}

# Attach policy to sns role to allow sns to publish messages to kinesis firehose
resource "aws_iam_role_policy" "sns_to_firehose_role_policy" {
  name   = "${var.name_prefix}-sns_to_firehose_role_policy"
  policy = data.aws_iam_policy_document.sns_to_firehose_role_assume_policy.json
  role   = aws_iam_role.sns_to_firehose_role.name
}


### IAM policies for glue
# Policy to allow glue to assume a role
data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

# Policy to allow glue access to the s3 bucket where the content of the delivery stream is stored
data "aws_iam_policy_document" "glue_access_bucket_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.s3_kinesis.arn,
      "${aws_s3_bucket.s3_kinesis.arn}/*",
    ]
  }
}

# Our Glue service role with assume role policy
resource "aws_iam_role" "glue_service_role" {
  name               = "${var.name_prefix}-glue_service_role"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
  tags               = var.tags
}


# AWS Managed glue service role policy
data "aws_iam_policy" "AWSGlueServiceRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# Attach managed aws glue policy to glue service role
resource "aws_iam_role_policy_attachment" "glue_service_role_policy" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = data.aws_iam_policy.AWSGlueServiceRole.arn
}

# Attach s3bucket policy to glue service role
resource "aws_iam_role_policy" "glue_access_bucket_policy" {
  name   = "${var.name_prefix}-glue_access_bucket_policy"
  policy = data.aws_iam_policy_document.glue_access_bucket_policy.json
  role   = aws_iam_role.glue_service_role.name
}