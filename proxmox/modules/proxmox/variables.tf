# ==============================================================
# modules/proxmox/variables.tf
# ==============================================================

variable "node_name" {
  type = string
}

variable "vm_id" {
  type = number
}

variable "vm_name" {
  type = string
}

variable "template_vm_id" {
  type = number
}

variable "vm_ip_address" {
  description = "IP tĩnh kèm prefix. Ví dụ: '9.9.9.230/24'"
  type        = string
}

variable "vm_ip_raw" {
  description = "IP không kèm prefix, dùng cho SSH. Ví dụ: '9.9.9.230'"
  type        = string
}

variable "vm_gateway" {
  type = string
}

variable "vm_user" {
  type    = string
  default = "vinh"
}

variable "vm_password" {
  type      = string
  sensitive = true
}

# ==============================================================
# Variables cho cấu hình tích hợp AWX
# Các giá trị này sẽ được điền từ Workspace Variables trên HCP
# ==============================================================

variable "awx_url" { 
  description = "Địa chỉ URL của máy chủ AWX (VD: https://awx.vinhthai.io.vn)"
  type        = string 
}

variable "awx_job_id" { 
  description = "ID của Workflow Job Template trên AWX"
  type        = string 
}

variable "awx_token" { 
  description = "Access Token của user AWX có quyền chạy Job"
  type        = string
  sensitive   = true 
}
