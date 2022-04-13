output "arn" {
  description = "Cluster ARN"
  value       = aws_ecs_cluster.cluster.arn
}

output "execution_role_arn" {
  description = "Execution IAM role ARN"
  value       = aws_iam_role.execution.arn
}

output "id" {
  description = "Cluster ID"
  value       = aws_ecs_cluster.cluster.id
}

output "name" {
  description = "Cluster Name"
  value       = aws_ecs_cluster.cluster.name
}

output "security_group_id" {
  description = "Security group ID attached to cluster instances"
  value       = aws_security_group.sg.id
}

output "tasks_log_group_name" {
  description = "Name of the CloudWatch logs group for cluster tasks"
  value       = aws_cloudwatch_log_group.tasks.name
}
