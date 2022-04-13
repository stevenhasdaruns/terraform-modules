output "id" {
  description = "Instance ID"
  value       = aws_instance.ec2.id
}

output "private_ip" {
  description = "Private IP Address"
  value       = aws_instance.ec2.private_ip
}

output "public_ip" {
  description = "Public IP Address"
  value       = aws_instance.ec2.public_ip
}

output "security_groups" {
  description = "Attached security groups"
  value       = aws_instance.ec2.security_groups
}

output "subnet_id" {
  description = "Subnet ID"
  value       = aws_instance.ec2.subnet_id
}
