# Proxmox API 접속 정보
# [주의] 이 파일은 .gitignore에 추가하여 버전 관리에 포함되지 않도록 하세요.
proxmox_api_url          = "https://192.168.0.3:8006/api2/json"
proxmox_api_token_id     = "terraform-prov@pve!terraform-token"
proxmox_api_token_secret = "e3f31683-a95e-42c3-b44b-9b24ea51bef3"

# 가상머신 구성 정보
vm_name       = "kosa-vm-05"
proxmox_node  = "masungil1"
template_name = "ubuntu-2204-template"
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDpwqCCgjmIB/BGIVPfwBW6ypFsc205Wx9uK1XGoEacX8irYel3vHjO/tQyuupim0jhQ3y6sWavfIsTAIa1Uc/t7UDjQvh3+hJNGkei3TEwalN0TzdKlWCYVeK+uZmpU4WFgXkESShlD2EoYdYXUlCotylvYqPmHI6LiTEnp8l//VfBBVmmTRyNby8qK3h/uxeq6hPqzaYPXnu3/sREAMQBtiVLQ3TojHuM8+CuYKZmtvWutWkgIVXFz+PZZQTuxfE73IpqJ617Rclu0Va61D7K1QdUfx/qXs20hUTUqzrtDnWLXI8qse9w5W4qon7nW1sg1AQ1HBCHqOp7yafpfUiJH533cibWOPn1Z7WpeJs0SG5AD6KKmi3tPX/DvuNHga42Ava82heubTVlNFuuqUbVZO6cUtE+69ZWYqDhMmuXhhyFtUEeU+JFTRTobJ0jg4sAuJ+t+ttob8ezFiyEE9ojYjanMMKsMvQRHaL+v2+/xpkeKuAZsm+SiNk9JZ+Rxy0= masun@masungil-notebk"


# Cloud-Init 정보
ciuser     = "kosa"
cipassword = "kosa1004"


# 네트워크 정보
static_ip = "192.168.0.4"
static_ip_cidr = 24
static_gateway = "192.168.0.1"
