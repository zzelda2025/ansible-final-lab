# ==============================================================
# main.tf — Root: Gọi Module Proxmox
# Terraform chỉ: tạo VM + chờ cloud-init
# Cài PostgreSQL & WireGuard do Ansible đảm nhiệm
# ==============================================================

module "proxmox_db" {
  source = "./modules/proxmox"

  # Node & VM identity
  node_name      = var.proxmox_node
  vm_id          = var.vm_id
  vm_name        = var.vm_name
  template_vm_id = var.template_vm_id

  # Network
  vm_ip_address = var.vm_ip_address
  vm_ip_raw     = var.vm_ip_raw
  vm_gateway    = var.vm_gateway

  # Credentials
  vm_user     = var.vm_user
  vm_password = var.vm_password
}

# ==============================================================
# Output — Webhook server lấy IP này qua HCP API
# ==============================================================
output "database_vm_ip" {
  description = "IP của VM Database (dùng cho Ansible webhook)"
  value       = module.proxmox_db.database_vm_ip
}
