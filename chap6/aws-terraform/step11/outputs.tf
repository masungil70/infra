output "instance_public_ips" {
  description = "The public IP addresses of the EC2 instances."
  value       = aws_instance.web[*].public_ip
}

output "instance_private_ips" {
  description = "The private IP addresses of the EC2 instances."
  value       = aws_instance.web[*].private_ip
}

output "instance_ids" {
  description = "The IDs of the EC2 instances."
  value       = aws_instance.web[*].id
}

output "instance_names" {
  description = "The names of the EC2 instances."
  value       = aws_instance.web[*].tags.Name
}

output "ssh_commands" {
  description = "Commands to SSH into each instance."
  value = [for i, ip in aws_instance.web[*].public_ip : "ssh -i kosa-server-key-${i + 1}.pem ${var.ci_user}@${ip}"]
}

output "private_key_files" {
  description = "The names of the generated private key files."
  value       = local_file.ssh_key[*].filename
}
