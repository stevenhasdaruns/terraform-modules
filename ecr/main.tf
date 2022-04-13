resource "aws_ecr_repository" "repo" {
  name = var.name
  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "untagged_retention" {
  repository = aws_ecr_repository.repo.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than ${var.untagged_retention} days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": ${var.untagged_retention}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
