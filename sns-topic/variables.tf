variable "name" {
  description = "The name of the topic"
  type        = string
}

variable "tags" {
  description = "Key/Value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "current_account" {
  description = "The owner account for the topic"
  type        = string
}

variable "external_subscribers" {
  description = "A list of accountnumbers that are allowed to create topic subscriptions"
  type        = list(string)
}

variable "enable_logging_of_published_messages" {
  description = "Enable logging of published messages to s3 using firehose delivery stream"
  type        = bool
  default     = false
}

variable "kinesis_firehose_delivery_stream_name" {
  type    = string
  default = ""
}

variable "sns_to_kinesis_role_name" {
  type    = string
  default = ""
}