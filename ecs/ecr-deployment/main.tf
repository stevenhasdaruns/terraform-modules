resource "aws_codebuild_project" "default" {
  name          = var.name
  description   = var.description
  build_timeout = var.build_timeout
  service_role  = var.service_codebuild_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "alpine"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "REPO_URI"
      value = "${var.repo_url}:${var.image_tag}"
    }

    environment_variable {
      name  = "NAME"
      value = var.name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "version: 0.2\n\nphases:\n  post_build:\n    commands:\n      - printf '[{\"name\":\"%s\",\"imageUri\":\"%s\"}]' $NAME $REPO_URI > imagedefinitions.json\nartifacts:\n    files: imagedefinitions.json"
  }

  tags = var.tags
}

resource "aws_codepipeline" "default" {
  name     = var.name
  role_arn = var.service_codepipeline_arn

  artifact_store {
    location = var.s3_codepipeline_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = "1"
      output_artifacts = ["source_container"]

      configuration = {
        ImageTag : var.image_tag
        RepositoryName : split("aws.com/", var.repo_url)[1]
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_container"]
      output_artifacts = ["imagedefinitions"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.default.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["imagedefinitions"]
      version         = "1"

      configuration = {
        ClusterName = var.cluster_name
        ServiceName = var.service_name
        FileName    = "imagedefinitions.json"
      }
    }
  }
}

# The resources below can be removed https://github.com/terraform-providers/terraform-provider-aws/issues/7012 is resolved.

resource "aws_cloudwatch_event_rule" "invoke" {
  name          = "ecs-codepipeline-${var.name}"
  description   = "Invoke ECR CodePipeline for ${var.name}"
  event_pattern = <<EVENT
{
    "source": [
        "aws.ecr"
    ],
    "detail-type": [
        "AWS API Call via CloudTrail"
    ],
    "detail": {
        "eventSource": [
            "ecr.amazonaws.com"
        ],
        "eventName": [
            "PutImage"
        ],
        "requestParameters": {
            "repositoryName": [
                "${split("aws.com/", var.repo_url)[1]}"
            ],
            "imageTag": [
                "${var.image_tag}"
            ]
        }
    }
}
EVENT

  tags       = var.tags
  depends_on = [aws_codepipeline.default]
}

resource "aws_cloudwatch_event_target" "pipeline" {
  rule     = aws_cloudwatch_event_rule.invoke.name
  arn      = aws_codepipeline.default.arn
  role_arn = var.role_codepipeline_invoke_arn
}
