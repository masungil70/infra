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
  description = "The base name of the EC2 instance(s)."
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

variable "vm_count" {
  description = "The number of EC2 instances to create."
  type        = number
  default     = 1
}

# User and SSH Key Variables
# For step11, we generate keys internally, so ssh_public_key is not directly used for the instance.
# However, if external SSH keys were to be used, it would be here.
# For consistency with Proxmox example, I will keep the variable for ciuser/cipassword
# and still use the generated SSH key within user_data.
variable "ssh_public_key" {
  description = "The public SSH key to be injected into the EC2 instance (not directly used by AWS key_pair here)."
  type        = string
  default     = "" # Not strictly used as we generate keys
  sensitive   = true
}

# local_private_key_path is not needed as keys are generated and saved locally
# variable "local_private_key_path" {
#   description = "The local path to the private SSH key used for remote-exec. e.g., ~/.ssh/id_rsa"
#   type        = string
#   sensitive   = true
#   default     = "~/.ssh/id_rsa"
# }

variable "ci_user" {
  description = "The username for the default user created by cloud-init."
  type        = string
}

variable "ci_password" {
  description = "The password for the default user. Be aware of security implications."
  type        = string
  sensitive   = true
}
