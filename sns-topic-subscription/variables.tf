variable "queue_name" {}
variable "tags" {}
variable "filter_policy" {
  type    = string
  default = ""
}
variable "delay_seconds" {
  type    = number
  default = 0
}
variable "max_message_size" {
  type    = number
  default = 262144
}
variable "message_retention_seconds" {
  type    = number
  default = 86400
}
variable "message_retention_seconds_dlq" {
  type    = number
  default = null
}
variable "receive_wait_time_seconds" {
  type    = number
  default = 20
}
variable "visibility_timeout_seconds" {
  type    = number
  default = 60
}
variable "fifo_queue" {
  type    = bool
  default = false
}

variable "enable_dlq" {
  type    = bool
  default = false
}

variable "max_receive_count" {
  type    = number
  default = 3
}

variable "enable_subscription" {
  type    = bool
  default = true
}

variable "sns_topic_arn" {
  type = string
}
