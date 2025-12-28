output "server_public_ips" {
  description = "The public IP addresses of the created EC2 instances."
  value       = module.ec2_servers.instance_public_ips
}

output "server_private_ips" {
  description = "The private IP addresses of the created EC2 instances."
  value       = module.ec2_servers.instance_private_ips
}

output "server_ids" {
  description = "The IDs of the created EC2 instances."
  value       = module.ec2_servers.instance_ids
}

output "server_names" {
  description = "The names of the created EC2 instances."
  value       = module.ec2_servers.instance_names
}
