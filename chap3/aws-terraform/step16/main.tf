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

# EC2 인스턴스 모듈 호출
module "ec2_server" {
  source = "./modules/ec2_instance" # 새로운 로컬 모듈

  # 모듈에 변수 전달
  instance_name   = var.base_instance_name
  instance_type   = var.instance_type
  ami_name_filter = var.ami_name_filter
  ssh_public_key  = var.ssh_public_key
  ci_config       = var.ci_config
  aws_region      = var.aws_region # 모듈 내부에서 VPC 등을 생성하기 위해 필요
}
