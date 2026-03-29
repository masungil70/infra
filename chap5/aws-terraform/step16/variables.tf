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
variable "base_instance_name" {
  description = "The base name for the EC2 instances and related resources."
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

# Cloud-Init Configuration Variable (Object type)
variable "ci_config" {
  description = "Configuration for Cloud-Init, including user, password, and SSH key."
  type = object({
    user     = string
    password = string
    ssh_key  = string
  })
  sensitive = true # Mark the entire object as sensitive
}

variable "ssh_public_key" {
  description = "The public SSH key to be injected into all EC2 instances. (Passed to module)"
  type        = string
  sensitive   = true
}
