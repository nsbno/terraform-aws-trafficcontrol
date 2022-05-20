### S3 bucket for kinesis firehose to store messages on the delivery stream
resource "aws_s3_bucket" "s3_kinesis" {
  bucket_prefix = "${var.name_prefix}-sns-kinesis-firehose"
  tags          = var.tags
}

resource "aws_s3_bucket_acl" "s3_kinesis_acl" {
  bucket = aws_s3_bucket.s3_kinesis.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_kinesis_bucket_lifecycle" {
  bucket = aws_s3_bucket.s3_kinesis.id

  rule {
    id     = "lifecycle"
    status = "Enabled"
    expiration {
      days = 30
    }
  }
}

### S3 bucket for athena to store queries and results
resource "aws_s3_bucket" "s3_athena_query" {
  bucket_prefix = "${var.name_prefix}-athena-query"
  tags = var.tags
}

resource "aws_s3_bucket_acl" "s3_athena_query_acl" {
  bucket = aws_s3_bucket.s3_athena_query.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_athena_bucket_lifecycle" {
  bucket = aws_s3_bucket.s3_athena_query.id

  rule {
    id     = "lifecycle"
    status = "Enabled"
    expiration {
      days = 7
    }
  }
}