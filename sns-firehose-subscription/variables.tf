variable "kinesis_firehose_delivery_stream_name" {
  type    = string
  default = ""
}

variable "sns_to_kinesis_role_name" {
  type    = string
  default = ""
}

variable "sns_topic_arn" {
  type    = string
  default = ""
}