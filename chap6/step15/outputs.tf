#output "server_ip" {
#  description = "서버의 기본 IPv4 주소입니다."
#  value = proxmox_vm_qemu.ubuntu_vm[*].default_ipv4_address
#}
#
## 생성된 VM들의 이름을 출력
#output "server_names" {
#  value = proxmox_vm_qemu.ubuntu_vm[*].name
#}

# 생성된 VM들의 IP 주소를 출력 (QEMU Agent가 IP를 가져올 때까지 시간이 걸릴 수 있음)
output "server_ips" {
  value = {
    for k, v in proxmox_vm_qemu.ubuntu_vm : k => v.default_ipv4_address
  }
}