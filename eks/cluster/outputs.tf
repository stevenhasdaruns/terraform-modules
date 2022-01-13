output "arn" {
  description = "Cluster ARN"
  value       = aws_eks_cluster.cluster.arn
}

output "assume_role_policy" {
  description = "JSON assume role policy roles the cluster pods can assume"
  value       = data.aws_iam_policy_document.assume_role_policy.json
}

output "endpoint" {
  description = "Cluster Endpoint"
  value       = aws_eks_cluster.cluster.endpoint
}

output "id" {
  description = "Cluster ID"
  value       = aws_eks_cluster.cluster.id
}

output "role_arn" {
  description = "Cluster role ARN"
  value       = aws_iam_role.cluster.arn
}

output "security_group_id" {
  description = "Security group created by EKS service for the cluster"
  value       = aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}
