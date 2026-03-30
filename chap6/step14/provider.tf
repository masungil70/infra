terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc06"
    }
  }
}

# Proxmox 프로바이더 구성 변수로 값을 설정합니다 
provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret

  # 자체 서명 인증서 사용 시 필요
  pm_tls_insecure = true
}
