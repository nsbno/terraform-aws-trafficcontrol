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
  description = "A list of account numbers that are allowed to create topic subscriptions"
  type        = list(string)
}

variable "create_payload_bucket" {
  description = "Whether to create an S3-bucket for large messages."
  type        = bool
}

variable "payload_bucket_name" {
  description = "Name of the SNS payload S3-bucket."
  type        = string
  default     = ""
}

variable "use_s3_bucket_lifecycle" {
  description = "Whether to apply an S3 bucket lifecycle configuration to the SNS topic S3 bucket."
  type        = bool
  default     = true
}

variable "s3_bucket_expiration_days" {
  description = "How many days to retain objects in S3 bucket before deleting them."
  type        = number
  default     = 7
}