# ==============================================================
# modules/proxmox/main.tf — Tạo VM Database trên Proxmox
# Terraform chỉ làm: tạo VM + chờ cloud-init
# Việc cài PostgreSQL và WireGuard do Ansible đảm nhiệm
# ==============================================================

terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66.0"
    }
  }
}

resource "proxmox_virtual_environment_vm" "db_server" {
  name      = var.vm_name
  node_name = var.node_name
  vm_id     = var.vm_id

  clone {
    vm_id   = var.template_vm_id
    full    = false
    retries = 3
  }

  timeout_clone  = 3600
  timeout_create = 3600

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  agent {
    enabled = false
  }

  initialization {
    user_account {
      username = var.vm_user
      password = var.vm_password
    }

    ip_config {
      ipv4 {
        address = var.vm_ip_address
        gateway = var.vm_gateway
      }
    }
  }

  started         = true
  on_boot         = true
  stop_on_destroy = true
}

# ==============================================================
# Chờ cloud-init xong — SSH sẵn sàng trước khi Ansible chạy
# ==============================================================
resource "null_resource" "wait_for_cloudinit" {
  triggers = {
    vm_id = proxmox_virtual_environment_vm.db_server.id
  }

  connection {
    type     = "ssh"
    host     = var.vm_ip_raw
    user     = var.vm_user
    password = var.vm_password
    timeout  = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cloud-init status --wait",
      "echo 'Cloud-init done, VM is ready for Ansible!'"
    ]
  }

  depends_on = [proxmox_virtual_environment_vm.db_server]
}

# ==============================================================
# Output — Ansible sẽ lấy IP này qua HCP API
# ==============================================================
output "database_vm_ip" {
  description = "IP của VM Database (dùng cho Ansible webhook)"
  value       = var.vm_ip_raw
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
