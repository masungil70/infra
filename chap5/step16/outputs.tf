# 생성된 VM들의 IP 주소를 출력 (QEMU Agent가 IP를 가져올 때까지 시간이 걸릴 수 있음)
output "server_ip" {
  description = "생성된 서버의 IP 주소."
  value       = module.proxmox_server.server_ip
}
