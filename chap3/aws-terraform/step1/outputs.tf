# 생성된 EC2 인스턴스의 공인 IP 주소를 출력합니다.
output "instance_public_ip" {
  description = "The public IP address of the EC2 instance."
  value       = aws_instance.web.public_ip
}

# 인스턴스에 SSH로 접속하는 명령어 템플릿을 출력합니다.
# <YOUR_PRIVATE_KEY_PATH> 부분을 실제 'home-key' 개인 키 파일의 경로로 바꾸어 사용해야 합니다.
output "ssh_command" {
  description = "Command to SSH into the instance. Replace <YOUR_PRIVATE_KEY_PATH> with the path to your private key."
  value       = "ssh -i <YOUR_PRIVATE_KEY_PATH> kosa@${aws_instance.web.public_ip}"
}
