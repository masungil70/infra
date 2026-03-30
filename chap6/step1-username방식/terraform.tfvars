proxmox_api_url          = "https://192.168.0.3:8006/api2/json"
# proxmox_api_token_id     = "terraform-prov@pve!terraform-token" # API 토큰 인증 대신 사용자 암호 인증을 위해 주석 처리
# proxmox_api_token_secret = "2df47429-9425-4ec5-8f12-765035cc3533" # API 토큰 인증 대신 사용자 암호 인증을 위해 주석 처리

pve_node       = "masungil1"
network_bridge = "vmbr0"
template_vm_id = 9000

# Proxmox 사용자의 실제 암호를 여기에 입력하세요.
proxmox_user_password = "kosa1004"
