variable "queue_name" {}
variable "topic_name" {}
variable "tags" {}
variable "filter_policy" {
  type = string
  default = ""
}