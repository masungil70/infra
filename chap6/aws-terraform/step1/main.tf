# 테라폼이 AWS 인증 정보를 코드 외부에서 찾도록 구성된 것입니다. 
# 이는 보안상 매우 권장되는 방식입니다. 인증 정보를 설정하는 몇 가지 방법이 있으며, 
# 그중 가장 일반적이고 안전한 두 가지 방법을 학습하겠습니다.
#
# 방법 1: 환경 변수 사용 (권장)
#
# 가장 간단한 방법은 터미널에서 AWS 인증 정보를 환경 변수로 설정하는 것입니다. 
# 이 설정은 현재 터미널 세션에만 적용되므로 보안에 유리합니다.
#
# Windows 명령 프롬프트(CMD)의 경우:
#
#  set AWS_ACCESS_KEY_ID=YOUR_AWS_ACCESS_KEY_ID
#  set AWS_SECRET_ACCESS_KEY=YOUR_AWS_SECRET_ACCESS_KEY
#
# Windows PowerShell의 경우:
#
#  $env:AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID"
#  $env:AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY"
#
# YOUR_AWS_ACCESS_KEY_ID와 YOUR_AWS_SECRET_ACCESS_KEY 부분을 실제 AWS IAM 사용자의 액세스 키와 시크릿 액세스 키로 바꾸어 입력한 뒤, 같은
# 터미널에서 terraform apply를 실행하면 됩니다.
#
# 방법 2: AWS 자격 증명 파일 사용
#
# 여러 프로젝트에서 동일한 AWS 계정을 사용하는 경우, 
# 자격 증명 파일을 설정하는 것이 편리합니다.
#
#  1. 파일 생성: C:\Users\사용자이름\.aws 폴더 안에 credentials 라는 이름의 파일을 생성합니다. (.aws 폴더가 없다면 새로 만들어주세요.)
#  2. 내용 입력: 파일에 아래와 같이 AWS 자격 증명 정보를 입력하고 저장합니다.
#
#  1     [default]
#  2     aws_access_key_id = YOUR_AWS_ACCESS_KEY_ID
#  3     aws_secret_access_key = YOUR_AWS_SECRET_ACCESS_KEY
#
# 마찬가지로 YOUR_AWS... 부분을 실제 키 값으로 변경해야 합니다. 
# 이렇게 설정하면 테라폼이 실행될 때 자동으로 이 파일을 읽어 인증을 수행합니다.

# Terraform AWS 공급자 설정
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS 공급자 구성
provider "aws" {
  region = var.aws_region
}

# EC2 인스턴스 리소스 정의
resource "aws_instance" "web" {
  ami           = var.ami
  # Proxmox 'cpu', 'memory'에 해당하는 인스턴스 타입
  instance_type = var.instance_type

  # Proxmox 'disk'에 해당하는 루트 블록 디바이스 설정
  root_block_device {
    volume_size = 8 # GB
  }

  # Cloud-Init 스크립트 (Proxmox 'ciuser', 'cipassword' 등)
  user_data = <<-EOF
              #cloud-config
              hostname: kosa-vm-01
              users:
                - name: kosa
                  sudo: ALL=(ALL) NOPASSWD:ALL
                  groups: [sudo, admin]
                  shell: /bin/bash
                  ssh_authorized_keys:
                    - ${var.ssh_public_key}
              chpasswd:
                list: |
                  kosa:kosa1004
                expire: False
              password_auth: true
              ssh_pwauth: true
              EOF
  
  # Proxmox 'name'에 해당하는 태그 설정
  tags = {
    Name = "kosa-vm-01"
  }

  # SSH 접속을 위한 키 페어 생성 및 사용
  # AWS에서 EC2에 접속하기 위한 표준적인 방법
  key_name = "home-key"
}
