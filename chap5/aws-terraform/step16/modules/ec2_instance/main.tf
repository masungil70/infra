# Custom VPC 생성
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.instance_name}-vpc"
  }
}

# Custom Subnet 생성
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true # 인스턴스가 Public IP를 받도록 설정
  tags = {
    Name = "${var.instance_name}-subnet"
  }
}

# Internet Gateway (IGW) 생성
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.instance_name}-igw"
  }
}

# Route Table 생성 및 IGW 연결
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

# Subnet과 Route Table 연결
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}


# Security Group 생성 (SSH 접속 허용)
resource "aws_security_group" "ssh_access" {
  name_prefix = "${var.instance_name}-ssh-"
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
    Name = "${var.instance_name}-ssh-sg"
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
  
  key_name             = aws_key_pair.imported_key.key_name
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  root_block_device {
    volume_size = 8
  }

  # Cloud-Init 스크립트. 사용자 이름, 암호, SSH 키를 ci_config 객체에서 가져옴
  user_data = <<-EOF
              #cloud-config
              hostname: ${var.instance_name}
              users:
                - name: ${var.ci_config.user}
                  sudo: ALL=(ALL) NOPASSWD:ALL
                  groups: [sudo, admin]
                  shell: /bin/bash
                  ssh_authorized_keys:
                    - ${var.ci_config.ssh_key}
              chpasswd:
                list: |
                  ${var.ci_config.user}:${var.ci_config.password}
                expire: False
              password_auth: true
              ssh_pwauth: true
              
              runcmd:
                - touch /etc/cloud/cloud-init.disabled
              EOF
  
  tags = {
    Name = var.instance_name
  }
}
