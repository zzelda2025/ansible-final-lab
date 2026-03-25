# ==============================================================
# main.tf — Root: Gọi Module AWS
# Terraform chỉ: tạo VPC + EC2 + ALB + EIP
# Cài WireGuard & Node.js do Ansible đảm nhiệm
# ==============================================================

module "aws_web" {
  source = "./modules/aws"

  aws_region           = var.aws_region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr_1 = var.public_subnet_cidr_1
  public_subnet_cidr_2 = var.public_subnet_cidr_2
  instance_type        = var.instance_type
  key_pair_name        = var.key_pair_name
}

# ==============================================================
# Outputs — Webhook server lấy IP này qua HCP API
# ==============================================================
output "ec2_public_ip" {
  description = "EIP của EC2 (dùng cho Ansible webhook)"
  value       = module.aws_web.ec2_public_ip
}

output "alb_dns_name" {
  description = "DNS của ALB"
  value       = module.aws_web.alb_dns_name
}
