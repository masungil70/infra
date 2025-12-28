output "server_ips" {
  description = "서버 이름과 IP 주소 맵."
  value = {
    for k, v in proxmox_vm_qemu.ubuntu_vm : k => v.default_ipv4_address
  }
}

output "server_ids" {
  description = "서버 이름과 Proxmox VM ID 맵."
  value = {
    for k, v in proxmox_vm_qemu.ubuntu_vm : k => v.vmid
  }
}
