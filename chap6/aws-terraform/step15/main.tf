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

# Custom VPC 생성 (step10과 동일)
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.base_instance_name}-vpc"
  }
}

# Custom Subnet 생성 (step10과 동일)
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true # 인스턴스가 Public IP를 받도록 설정
  tags = {
    Name = "${var.base_instance_name}-subnet"
  }
}

# Internet Gateway (IGW) 생성 (step10과 동일)
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.base_instance_name}-igw"
  }
}

# Route Table 생성 및 IGW 연결 (step10과 동일)
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.base_instance_name}-rt"
  }
}

# Subnet과 Route Table 연결 (step10과 동일)
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}


# Security Group 생성 (SSH 접속 허용)
resource "aws_security_group" "ssh_access" {
  name_prefix = "${var.base_instance_name}-ssh-"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 모든 IP에서 SSH 허용 (보안 강화를 위해 특정 IP로 제한 권장)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.base_instance_name}-ssh-sg"
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
  key_name   = "${var.base_instance_name}-key"
  public_key = var.ssh_public_key
}

# EC2 인스턴스 리소스 정의
resource "aws_instance" "web" {
  for_each = var.vms # var.vms 맵의 각 항목에 대해 인스턴스 생성

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_map[each.value.cores][each.value.memory] # cores와 memory에 따라 인스턴스 타입 결정
  subnet_id     = aws_subnet.main.id
  
  key_name             = aws_key_pair.imported_key.key_name
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  root_block_device {
    volume_size = each.value.disk_gb # 각 VM의 disk_gb에 따라 디스크 크기 설정
  }

  # Cloud-Init 스크립트
  user_data = <<-EOF
              #cloud-config
              hostname: ${each.value.name} # 각 VM의 name 속성 사용
              users:
                - name: ${var.ciuser}
                  sudo: ALL=(ALL) NOPASSWD:ALL
                  groups: [sudo, admin]
                  shell: /bin/bash
                  ssh_authorized_keys:
                    - ${var.ssh_public_key}
              chpasswd:
                list: |
                  ${var.ciuser}:${var.cipassword}
                expire: False
              password_auth: true
              ssh_pwauth: true
              
              runcmd:
                - touch /etc/cloud/cloud-init.disabled
              EOF
  
  tags = {
    Name = each.value.name
    Tags = each.value.tags # Proxmox tags 필드를 AWS Tags로
  }
}
