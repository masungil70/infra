# AWS Provider Variables
variable "aws_access_key" {
  description = "AWS access key. For educational purposes. Use IAM roles in production."
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key. For educational purposes. Use IAM roles in production."
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
}

# EC2 Instance Variables
variable "instance_name" {
  description = "The name of the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch."
  type        = string
  default     = "t2.micro"
}

variable "ami_name_filter" {
  description = "The name filter to find the latest AMI."
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

# User and SSH Key Variables
variable "ssh_public_key" {
  description = "The public SSH key to be injected into the EC2 instance."
  type        = string
  sensitive   = true
}

variable "local_private_key_path" {
  description = "The local path to the private SSH key used for remote-exec. e.g., ~/.ssh/id_rsa"
  type        = string
  sensitive   = true
}

variable "ci_user" {
  description = "The username for the default user created by cloud-init."
  type        = string
}

variable "ci_password" {
  description = "The password for the default user. Be aware of security implications."
  type        = string
  sensitive   = true
}

# Network Variables
variable "static_private_ip" {
  description = "The static private IP address to assign to the EC2 instance."
  type        = string
}
