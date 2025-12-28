# 1. 사용할 Terraform 및 Provider 버전 설정
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.41.0"
    }
  }
}

# 2. Proxmox Provider 연결을 위한 변수
variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API URL (e.g., https://192.168.0.100:8006/api2/json)"
}

# 3. VM 생성을 위한 변수
variable "pve_node" {
  type        = string
  description = "VM을 생성할 Proxmox 노드 이름"
  default     = "pve"
}

variable "template_vm_id" {
  type        = number
  description = "복제할 VM 템플릿의 숫자 ID (예: 100). Proxmox UI에서 확인하세요."
}

variable "network_bridge" {
  type        = string
  description = "VM에서 사용할 네트워크 브릿지"
  default     = "vmbr0"
}

variable "proxmox_user_password" {
  type        = string
  description = "Proxmox 사용자의 실제 암호"
  sensitive   = true
}


# 4. Proxmox Provider 설정
provider "proxmox" {
  endpoint = var.proxmox_api_url
  username = "terraform-prov@pve" # [수정] 토큰 ID 대신 사용자 이름으로 인증
  password = var.proxmox_user_password # [수정] 토큰 Secret 대신 사용자 암호로 인증
  insecure = true
}

# 5. 리소스 생성 (VM 템플릿 복제)
resource "proxmox_virtual_environment_vm" "test_vm" {
  name      = "terraform-vm-01"
  node_name = var.pve_node

  clone {
    vm_id   = var.template_vm_id
    full    = true
  }

  operating_system {
    type = "l26"
  }

  cpu {
    cores   = 2
    sockets = 1
  }

  memory {
    dedicated = 2048
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = var.network_bridge
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  # [수정] 템플릿의 실제 디스크 인터페이스인 'virtio0'를 대상으로 크기를 조절합니다.
  disk {
    interface = "virtio0"
    size      = 32
  }
}
