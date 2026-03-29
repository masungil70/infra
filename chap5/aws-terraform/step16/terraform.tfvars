# AWS Provider Configuration
# [보안 주의] 실제 운영 환경에서는 AWS 자격증명을 파일에 저장하지 마세요.
aws_access_key = "YOUR_AWS_ACCESS_KEY"
aws_secret_key = "YOUR_AWS_SECRET_KEY"
aws_region     = "ap-northeast-2"

# EC2 Instance Configuration
base_instance_name = "kosa-vm-16" # Updated for step16
instance_type      = "t2.micro"
# ami_name_filter = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" # Default is fine

# User and SSH Key Configuration
# [보안 주의] 여기에 실제 SSH 공개 키를 입력하세요.
# 예: ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAA..."
ssh_public_key = "YOUR_SSH_PUBLIC_KEY"

# Cloud-Init User Configuration (as an object)
ci_config = {
  user     = "kosa"
  password = "kosa1004"
  # Note: The ssh_key within ci_config is not used directly by aws_key_pair in this step,
  # but passed for consistency with the Proxmox module. The root ssh_public_key is used instead.
  ssh_key  = "YOUR_SSH_PUBLIC_KEY_FOR_CLOUD_INIT" 
}
