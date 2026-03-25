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
