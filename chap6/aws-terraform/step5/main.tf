# 가장 최신 Ubuntu AMI를 동적으로 찾기
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# 사용자가 제공한 SSH 공개키로 AWS 키 페어 생성
resource "aws_key_pair" "imported_key" {
  # 키 이름은 식별하기 쉽게 인스턴스 이름과 접미사를 조합
  key_name   = "${var.instance_name}-key"
  public_key = var.ssh_public_key
}

# EC2 인스턴스 리소스 정의
resource "aws_instance" "web" {
  # 변수로부터 AMI ID와 인스턴스 타입 설정
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  # 생성된 키 페어 사용
  key_name = aws_key_pair.imported_key.key_name

  root_block_device {
    volume_size = 8
  }

  # Cloud-Init 스크립트. 사용자 이름, 암호, SSH 키를 변수에서 가져옴
  user_data = <<-EOF
              #cloud-config
              hostname: ${var.instance_name}
              users:
                - name: ${var.ci_user}
                  sudo: ALL=(ALL) NOPASSWD:ALL
                  groups: [sudo, admin]
                  shell: /bin/bash
                  ssh_authorized_keys:
                    - ${var.ssh_public_key}
              chpasswd:
                list: |
                  ${var.ci_user}:${var.ci_password}
                expire: False
              password_auth: true
              ssh_pwauth: true
              EOF
  
  # 인스턴스 태그 설정
  tags = {
    Name = var.instance_name
  }
}
