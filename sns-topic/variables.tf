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