variable "environment" { type = string, default = "stage" }
variable "vpc_cidr" { type = string, default = "10.65.0.0/16" }
variable "public_subnets" { type = list(string), default = ["10.65.0.0/19","10.65.32.0/19"] }
variable "private_subnets" { type = list(string), default = ["10.65.64.0/19","10.65.96.0/19"] }