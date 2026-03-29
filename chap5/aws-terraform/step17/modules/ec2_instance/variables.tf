# Input variables for the EC2 instance module
variable "vms" {
  description = "A map of objects defining the configuration for each VM to be created."
  type = map(object({
    name    = string
    cores   = number
    memory  = number
    disk_gb = number
    tags    = string
  }))
}

variable "ami_name_filter" {
  description = "The name filter to find the latest AMI."
  type        = string
}

variable "ssh_public_key" {
  description = "The public SSH key to be injected into all EC2 instances."
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

variable "aws_region" {
  description = "The AWS region where the resources will be created."
  type        = string
}

variable "instance_type_map" {
  description = "A map to determine instance type based on cores and memory."
  type = map(map(string))
  default = {
    "1" = {
      "1024" = "t2.micro"
      "2048" = "t2.small"
      "4096" = "t2.medium"
    }
    "2" = {
      "2048" = "t2.small"
      "4096" = "t2.medium"
      "8192" = "t2.large"
    }
    "4" = {
      "4096" = "t2.medium"
      "8192" = "t2.large"
    }
  }
}
