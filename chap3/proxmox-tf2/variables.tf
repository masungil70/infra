# Proxmox 프로바이더 연결에 필요한 변수
variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API의 전체 URL 주소 (예: https://1.2.3.4:8006/api2/json)"
  sensitive   = true
}

variable "proxmox_api_token_id" {
  type        = string
  description = "Proxmox API 토큰 ID (예: user@pve!token-name)"
  sensitive   = true
}

variable "proxmox_api_token_secret" {
  type        = string
  description = "Proxmox API 토큰 Secret"
  sensitive   = true
}

# VM 생성을 위해 필요한 변수
variable "vm_configs" {
  type = map(object({
    ip_address = string
  }))
  description = "생성할 가상머신들의 구성 맵. 키는 VM 이름입니다."
}

variable "proxmox_node" {
  type        = string
  description = "VM을 생성할 대상 Proxmox 노드의 이름"
}

variable "template_name" {
  type        = string
  description = "복제에 사용할 템플릿의 이름"
}

variable "ssh_public_key" {
  type        = string
  description = "VM에 주입할 사용자의 SSH 공개 키"
  sensitive   = true
}