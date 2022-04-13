output "arn" {
  description = "File system ARN"
  value       = aws_efs_file_system.fs.arn
}

output "id" {
  description = "File system ID"
  value       = aws_efs_file_system.fs.id
}

output "dns_name" {
  description = "File system DNS Name"
  value       = aws_efs_file_system.fs.dns_name
}

output "mount_target_ip" {
  description = "IP in each respective subnet/AZ for mounting"
  value       = { for k, v in aws_efs_mount_target.mt : k => v.ip_address }
}

output "security_group_id" {
  description = "Security group ID allowing ingress to mount targets"
  value       = aws_security_group.default.id
}
