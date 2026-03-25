# ==============================================================
# terraform.tf — HCP Terraform + Proxmox Provider
# ==============================================================

terraform {
  cloud {
    organization = "Devops-HTV"
    workspaces {
      name = "proxmox-infra"
    }
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66.0"
    }
  }

  required_version = ">= 1.6.0"
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true

  ssh {
    agent    = false
    username = var.proxmox_ssh_user
    password = var.proxmox_ssh_password
  }
}
