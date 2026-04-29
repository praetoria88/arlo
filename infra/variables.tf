variable "aws_region" {
  type        = string
  default     = "ap-southeast-2"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_connection_param_name" {
  type = string
}

variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name"
  type        = string
  default     = "my-api-artifacts"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}