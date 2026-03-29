output "instance_public_ips" {
  description = "The public IP addresses of the EC2 instances."
  value       = { for k, v in aws_instance.web : k => v.public_ip }
}

output "instance_private_ips" {
  description = "The private IP addresses of the EC2 instances."
  value       = { for k, v in aws_instance.web : k => v.private_ip }
}

output "instance_ids" {
  description = "The IDs of the EC2 instances."
  value       = { for k, v in aws_instance.web : k => v.id }
}

output "instance_names" {
  description = "The names of the EC2 instances."
  value       = { for k, v in aws_instance.web : k => v.tags.Name }
}
