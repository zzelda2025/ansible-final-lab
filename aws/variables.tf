# ==============================================================
# variables.tf — Root Level (AWS)
# ==============================================================

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  description = "CIDR block cho VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  description = "CIDR Public Subnet 1 (AZ-a)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  description = "CIDR Public Subnet 2 (AZ-b)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Tên Key Pair đã tạo trên AWS Console"
  type        = string
}

variable "awx_url" { 
  description = "Địa chỉ URL của máy chủ AWX"
  type        = string 
}

variable "awx_workflow_id" { 
  description = "ID của Workflow Job Template trên AWX dành riêng cho AWS"
  type        = string 
}

variable "awx_token" { 
  description = "Access Token của user AWX"
  type        = string
  sensitive   = true 
}
