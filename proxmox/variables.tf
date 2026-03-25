# ==============================================================
# variables.tf — Root Level (Proxmox)
# ==============================================================

# ── Proxmox Connection ────────────────────────────────────────
variable "proxmox_endpoint" {
  description = "URL API Proxmox. Ví dụ: https://192.168.1.10:8006"
  type        = string
}

variable "proxmox_api_token" {
  description = "API Token của Proxmox. Format: user@pam!token=uuid"
  type        = string
  sensitive   = true
}

variable "proxmox_ssh_user" {
  description = "User SSH cho Proxmox host"
  type        = string
  default     = "root"
}

variable "proxmox_ssh_password" {
  description = "Password SSH của Proxmox host"
  type        = string
  sensitive   = true
}

# ── VM Config ─────────────────────────────────────────────────
variable "proxmox_node" {
  description = "Tên node Proxmox"
  type        = string
  default     = "pve"
}

variable "vm_id" {
  description = "VM ID (unique trong Proxmox cluster)"
  type        = number
  default     = 200
}

variable "template_vm_id" {
  description = "VM ID của template để clone"
  type        = number
  default     = 201
}

variable "vm_name" {
  description = "Tên hiển thị của VM"
  type        = string
  default     = "database-vm"
}

variable "vm_ip_address" {
  description = "IP tĩnh kèm prefix. Ví dụ: '9.9.9.230/24'"
  type        = string
}

variable "vm_gateway" {
  description = "Default gateway. Ví dụ: '9.9.9.254'"
  type        = string
}

variable "vm_ip_raw" {
  description = "IP không kèm prefix, dùng cho SSH. Ví dụ: '9.9.9.230'"
  type        = string
}

# ── VM Credentials ────────────────────────────────────────────
variable "vm_user" {
  description = "Username SSH vào VM"
  type        = string
  default     = "vinh"
}

variable "vm_password" {
  description = "Password SSH vào VM"
  type        = string
  sensitive   = true
}
