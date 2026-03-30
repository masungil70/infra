# Input variables for the EC2 instance module
variable "instance_name" {
  description = "The name of the EC2 instance and related resources."
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch."
  type        = string
}

variable "ami_name_filter" {
  description = "The name filter to find the latest AMI."
  type        = string
}

variable "ssh_public_key" {
  description = "The public SSH key to be injected into the EC2 instance."
  type        = string
  sensitive   = true
}

variable "ci_config" {
  description = "Configuration for Cloud-Init, including user, password, and SSH key."
  type = object({
    user     = string
    password = string
    ssh_key  = string
  })
  sensitive = true
}

variable "aws_region" {
  description = "The AWS region where the resources will be created."
  type        = string
}
