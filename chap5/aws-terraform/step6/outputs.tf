output "instance_public_ip" {
  description = "The public IP address of the EC2 instance."
  value       = aws_instance.web.public_ip
}

output "ssh_user" {
  description = "The user to SSH as."
  value       = var.ci_user
}

output "instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.web.id
}

output "key_pair_name" {
  description = "The name of the AWS key pair created."
  value       = aws_key_pair.imported_key.key_name
}
