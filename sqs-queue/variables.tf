variable "queue_name" {}
variable "tags" {}
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
variable "enable_dlq_alarm" {
  type    = bool
  default = false
}
variable "alarm_topic_arn" {
  description = "Arn to the sns topic that publish alarms"
  type = string
  default = ""
}
variable "max_receive_count" {
  type    = number
  default = 3
}