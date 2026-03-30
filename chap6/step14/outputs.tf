output "server_ips" {
  description = "서버의 기본 IPv4 주소입니다."
  value = {
    for k, v in proxmox_vm_qemu.ubuntu_vm : k => v.default_ipv4_address
  }
}