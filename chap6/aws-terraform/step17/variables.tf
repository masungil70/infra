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
  default     = "ap-northeast-2"
}

# EC2 Instance Variables for the Module
variable "ami_name_filter" {
  description = "The name filter to find the latest AMI."
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

# User and SSH Key Variables (common for all VMs)
variable "ssh_public_key" {
  description = "The public SSH key to be injected into all EC2 instances. (Passed to module)"
  type        = string
  sensitive   = true
}

variable "ciuser" {
  description = "Cloud-Init user name for all instances."
  type        = string
}

variable "cipassword" {
  description = "Cloud-Init user password for all instances."
  type        = string
  sensitive   = true
}

# VMs Configuration (map of objects)
variable "vms" {
  description = "A map of objects defining the configuration for each VM."
  type = map(object({
    name    = string
    cores   = number
    memory  = number
    disk_gb = number
    tags    = string
  }))
}
