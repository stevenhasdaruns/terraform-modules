output "id" {
  description = "ALB ID"
  value       = aws_alb.alb.id
}

output "dns_name" {
  description = "DNS name"
  value       = aws_alb.alb.dns_name
}

output "zone_id" {
  description = "Canonical hosted zone ID of the load balancer.  Used for Route 53 entries."
  value       = aws_alb.alb.zone_id
}

output "security_group_id" {
  description = "Security group allowed access to the ALB."
  value       = aws_security_group.alb.id
}
