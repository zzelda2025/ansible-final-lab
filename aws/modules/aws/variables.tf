# ==============================================================
# modules/aws/variables.tf
# ==============================================================

variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr_1" {
  type = string
}

variable "public_subnet_cidr_2" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_pair_name" {
  description = "Tên Key Pair để SSH vào EC2"
  type        = string
}
