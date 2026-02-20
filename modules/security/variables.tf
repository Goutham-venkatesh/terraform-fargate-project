variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}