# AWS Provider Configuration
# [보안 주의] 실제 운영 환경에서는 AWS 자격증명을 파일에 저장하지 마세요.
aws_access_key = "YOUR_AWS_ACCESS_KEY"
aws_secret_key = "YOUR_AWS_SECRET_KEY"
aws_region     = "ap-northeast-2"

# EC2 Instance Configuration
instance_name = "kosa-server" # Updated for step11
instance_type = "t2.micro"
# 특정 AMI를 원할 경우 ami_name_filter를 수정할 수 있습니다.
# ami_name_filter = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"

vm_count = 3 # Number of instances to create

# User and SSH Key Configuration
# Note: For step11, SSH keys are generated internally and saved to local files.
# The ssh_public_key variable is kept for consistency but not directly used by aws_key_pair here.
ssh_public_key = "dummy_public_key_for_internal_generation_only" # Not used by aws_key_pair

# Cloud-Init User Configuration
ci_user     = "kosa"
ci_password = "kosa1004"
