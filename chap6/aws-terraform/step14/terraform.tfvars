# AWS Provider Configuration
# [보안 주의] 실제 운영 환경에서는 AWS 자격증명을 파일에 저장하지 마세요.
aws_access_key = "YOUR_AWS_ACCESS_KEY"
aws_secret_key = "YOUR_AWS_SECRET_KEY"
aws_region     = "ap-northeast-2"

# EC2 Instance Configuration
instance_name = "kosa-vm-14" # Updated for step14
instance_type = "t2.micro"
# 특정 AMI를 원할 경우 ami_name_filter를 수정할 수 있습니다.
# ami_name_filter = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"

# Cloud-Init User Configuration (as an object)
ci_config = {
  user     = "kosa"
  password = "kosa1004"
  # [보안 주의] 여기에 실제 SSH 공개 키를 입력하세요.
  # 예: ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAA..."
  ssh_key  = "YOUR_SSH_PUBLIC_KEY" 
} 

# Network Configuration
static_ips = ["10.0.1.10", "10.0.1.11", "10.0.1.10"] # List with a duplicate to show toset() effect
