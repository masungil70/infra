output "server_public_ip" {
  description = "The public IP address of the created EC2 instance."
  value       = module.ec2_server.instance_public_ip
}

output "server_private_ip" {
  description = "The private IP address of the created EC2 instance."
  value       = module.ec2_server.instance_private_ip
}
