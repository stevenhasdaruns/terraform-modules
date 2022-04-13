output "arn" {
  description = "Repository ARN"
  value       = aws_ecr_repository.repo.arn
}

output "name" {
  description = "Repository name"
  value       = aws_ecr_repository.repo.name
}

output "url" {
  description = "Repository URL form"
  value       = aws_ecr_repository.repo.repository_url
}
