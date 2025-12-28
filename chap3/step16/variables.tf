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
variable "vm_name" {
  type        = string
  description = "생성할 가상머신의 이름"
}

variable "proxmox_node" {
  type        = string
  description = "VM을 생성할 대상 Proxmox 노드의 이름"
}

variable "template_name" {
  type        = string
  description = "복제에 사용할 템플릿의 이름"
}

# cloud-init 및 ssh 공개키 설정시 사용될 변수를 Object 타입으로 선언
variable "ciValue" {
  type = object({
    user    = string     # "Cloud-Init 사용자 이름"
    password = string # "Cloud-Init 사용자 암호"
    ssh_key  = string  # "VM에 주입할 사용자의 SSH 공개 키"
  })
  description = "cloud-init 및 ssh 공개키 설정시 사용될 변수"
  sensitive   = true
}
