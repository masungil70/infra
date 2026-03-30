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
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Custom VPC 생성 (step8과 동일)
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.instance_name}-vpc"
  }
}

# Custom Subnet 생성 (step8과 동일)
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.instance_name}-subnet"
  }
}

# Internet Gateway (IGW) 생성 (step8과 동일)
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.instance_name}-igw"
  }
}

# Route Table 생성 및 IGW 연결 (step8과 동일)
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.instance_name}-rt"
  }
}

# Subnet과 Route Table 연결 (step8과 동일)
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Security Group 생성 (SSH 및 HTTP 접속 허용)
resource "aws_security_group" "access" {
  name_prefix = "${var.instance_name}-access-"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP for Nginx
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.instance_name}-sg"
  }
}


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
  key_name   = "${var.instance_name}-key"
  public_key = var.ssh_public_key
}

# EC2 인스턴스 리소스 정의
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id
  private_ip    = var.static_private_ip
  
  key_name             = aws_key_pair.imported_key.key_name
  vpc_security_group_ids = [aws_security_group.access.id]

  root_block_device {
    volume_size = 8
  }

  # Cloud-Init 스크립트
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
              
              runcmd:
                - touch /etc/cloud/cloud-init.disabled
              EOF
  
  tags = {
    Name = var.instance_name
  }

  # remote-exec 프로비저너: 인스턴스에 Nginx 설치
  # Proxmox의 qemu-guest-agent 설치에 해당
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    # SSH 연결 정보: EC2 인스턴스의 공용 IP와 사용자 제공 SSH 키 사용
    connection {
      type        = "ssh"
      user        = var.ci_user
      private_key = file(var.local_private_key_path) # 로컬 PC의 개인키 파일 경로
      host        = self.public_ip # EC2 인스턴스의 공용 IP
      timeout     = "5m"
    }
  }
}
