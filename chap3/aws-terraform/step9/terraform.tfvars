# AWS Provider Configuration
# [보안 주의] 실제 운영 환경에서는 AWS 자격증명을 파일에 저장하지 마세요.
aws_access_key = "YOUR_AWS_ACCESS_KEY"
aws_secret_key = "YOUR_AWS_SECRET_KEY"
aws_region     = "ap-northeast-2"

# EC2 Instance Configuration
instance_name = "kosa-vm-09" # Updated for step9
instance_type = "t2.micro"
# 특정 AMI를 원할 경우 ami_name_filter를 수정할 수 있습니다.
# ami_name_filter = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"

# User and SSH Key Configuration
# [보안 주의] 여기에 실제 SSH 공개 키를 입력하세요.
# 예: ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAA..."
ssh_public_key = "YOUR_SSH_PUBLIC_KEY"

# [보안 주의] 로컬 개인 키 경로를 정확히 지정해야 합니다.
# 예: local_private_key_path = "~/.ssh/id_rsa"
local_private_key_path = "PATH_TO_YOUR_PRIVATE_SSH_KEY_FILE"


# Cloud-Init User Configuration
ci_user     = "kosa"
ci_password = "kosa1004"

# Network Configuration
static_private_ip = "10.0.1.101" # Ensure this IP is available within the subnet (10.0.1.0/24)
