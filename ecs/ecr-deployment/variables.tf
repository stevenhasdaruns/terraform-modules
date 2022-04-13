
variable "build_timeout" {
  description = "CodeBuild project timeout in minutes"
  default     = 5
  type        = number
}

variable "cluster_name" {
  description = "Target ECS cluster Name"
  type        = string
}

variable "description" {
  description = "CodeBuild description"
  default     = "ECR to ECS imagedefinitions.json builder."
  type        = string
}

variable "image_tag" {
  description = "Image tag to be deployed."
  default     = "latest"
  type        = string
}

variable "name" {
  description = "Used by CodeBuild and CodePipeline.  Recommend container name."
  type        = string
}

variable "repo_url" {
  description = "Source ECR repository URL - E.g 999999999999.dkr.ecr.us-east-1.amazonaws.com/example-repo"
  type        = string
}

variable "role_codepipeline_invoke_arn" {
  description = "ARN of the IAM role that allows CloudWatch Events to invoke CodePipeline"
  type        = string
}

variable "s3_codepipeline_bucket" {
  description = "S3 CodePipeline Bucket"
  type        = string
}

variable "service_codebuild_arn" {
  description = "CodeBuild Service Role ARN"
  type        = string
}

variable "service_codepipeline_arn" {
  description = "CodePipeline Service Role ARN"
  type        = string
}

variable "service_name" {
  description = "Target ECS Service Name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all module resources."
  default     = {}
  type        = map
}
