output "pipeline_arn" {
  description = "CodePipeline ARN"
  value       = aws_codepipeline.default.arn
}

output "pipeline_id" {
  description = "CodePipeline ID"
  value       = aws_codepipeline.default.id
}

output "project_arn" {
  description = "CodeBuild project ARN"
  value       = aws_codebuild_project.default.arn
}

output "project_name" {
  description = "CodeBuild project name"
  value       = aws_codebuild_project.default.name
}
