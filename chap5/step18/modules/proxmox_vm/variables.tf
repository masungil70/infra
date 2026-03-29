variable "vms" {
  description = "생성할 가상 머신 맵."
  type = map(object({
    name    = string
    cores   = number
    memory  = number
    disk_gb = number
    tags    = string
  }))
}

variable "proxmox_node" {
  type        = string
  description = "VM을 생성할 Proxmox 노드."
}

variable "template_name" {
  type        = string
  description = "복제할 템플릿 이름."
}

variable "ssh_public_key" {
  type        = string
  description = "VM에 주입할 사용자의 SSH 공개 키."
  sensitive   = true
}

variable "ciuser" {
  type        = string
  description = "Cloud-Init 사용자 이름."
}

variable "cipassword" {
  type        = string
  description = "Cloud-Init 사용자 암호."
  sensitive   = true
}
