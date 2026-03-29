# AWS 리전 변수 정의
variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "ap-northeast-2" # 기본값: 서울 리전
}

# EC2 인스턴스 유형 변수 정의
variable "instance_type" {
  description = "The type of EC2 instance to launch."
  type        = string
  default     = "t2.micro" # 기본값: 프리티어에서 사용 가능한 t2.micro
}

variable "ami" {
  default = "ami-0a71e3eb8b23101ed"
}

variable "ssh_public_key" {
  description = "The public key for the 'home-key' key pair."
  type        = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmGXWvyiaPorV7hcypEDqvj596FVXOpWLHmZBs2zmtG7yWLaojQlBI8p8mpR6gaOQfg/Wh7rDPz0zYiO3Tn004HLfooTO2KuLW8jkC9ukQKug6tm2W5d2SWNJCZUiSfuEmc+6PbhiPb8mOdCt3G2ek/xwLt2jDiLL/2r+pNsm8Lr+SurPhtUtjJAWTnJGzbK2UmiAs/dMGaoyCcagl/GJTNbZIZnlLKVkx1wOgLMBZLujWZ6DVlah2wEx0Y0y71YB5yPezIz+RQlXkl89xlDYHhGhiBHMgFCbRTs7KYYR5hljDpB2W/8kor7OsRf3apRFvgEHQk/3bkCWTsd+ryrsX home-key"
}
