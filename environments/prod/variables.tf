variable "environment" { type = string, default = "prod" }
variable "vpc_cidr" { type = string, default = "10.66.0.0/16" }
variable "public_subnets" { type = list(string), default = ["10.66.0.0/19","10.66.32.0/19"] }
variable "private_subnets" { type = list(string), default = ["10.66.64.0/19","10.66.96.0/19"] }