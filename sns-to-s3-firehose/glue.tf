### Create the glue catalog database where the crawler can store the parsed data
resource "aws_glue_catalog_database" "sns_glue_database" {
  name = "${var.name_prefix}-sns-messages-database"
}

### Create a glue crawler to populate the database.
# Scheduled to run every 3 hours
# Using a glue service role specified in the iam.tf file.
# Configured to parse the incoming kinesis firehose bucket.
resource "aws_glue_crawler" "glue_crawler" {
  database_name = aws_glue_catalog_database.sns_glue_database.name
  schedule      = "cron(0 */3 * * ? *)"
  name          = "${var.name_prefix}-sns-messages-crawler"
  role          = aws_iam_role.glue_service_role.name

  s3_target {
    path = "s3://${aws_s3_bucket.s3_kinesis.bucket}"
  }
}