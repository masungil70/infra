output "server_ip" {
  description = "서버의 기본 IPv4 주소입니다."
  value = proxmox_vm_qemu.ubuntu_vm[*].default_ipv4_address
}

# 생성된 VM들의 이름을 출력
output "server_names" {
  value = proxmox_vm_qemu.ubuntu_vm[*].name
}
