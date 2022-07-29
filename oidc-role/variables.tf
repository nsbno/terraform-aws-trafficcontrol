variable "name_prefix" {
  description = "A prefix used for naming resources."
}

variable "allowed_s3_write_arns" {
  description = "A list of ARNs of S3 buckets that the user can write to."
  default     = []
  type        = list(string)
}

variable "allowed_s3_read_arns" {
  description = "A list of ARNs of S3 buckets that the user can read from."
  default     = []
  type        = list(string)
}

variable "allowed_ecr_arns" {
  description = "A list of ARNs of ECR repositories that the user can read from and write to."
  default     = []
  type        = list(string)
}

variable "repository_list" {
    description = "A list of repositories that the OIDC role can access"
    default     = []
    type        = list(string)
}