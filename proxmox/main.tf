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

# ==============================================================
# Gọi API AWX ngay sau khi VM Proxmox đã sẵn sàng
# ==============================================================
resource "null_resource" "trigger_awx_workflow" {
  # Bắt buộc phải đợi module proxmox_db hoàn thành (đã chạy xong cloud-init)
  depends_on = [module.proxmox_db]

  triggers = {
    # Lấy IP từ output của module để so sánh, IP đổi thì gọi lại AWX
    vm_ip = module.proxmox_db.database_vm_ip
  }

  provisioner "local-exec" {
    # Truyền trực tiếp IP vào payload của AWX
    command = <<EOF
      curl -s -k -X POST ${var.awx_url}/api/v2/workflow_job_templates/${var.awx_job_id}/launch/ \
      -H "Authorization: Bearer ${var.awx_token}" \
      -H "Content-Type: application/json" \
      -d '{"extra_vars": {"target_ip": "${module.proxmox_db.database_vm_ip}"}}'
    EOF
  }
}
