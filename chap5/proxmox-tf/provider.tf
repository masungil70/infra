terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc06"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://192.168.0.3:8006/api2/json"
  pm_api_token_id = "terraform-prov@pve!terraform-token"
  pm_api_token_secret = "e3f31683-a95e-42c3-b44b-9b24ea51bef3"
  pm_tls_insecure = true
}
