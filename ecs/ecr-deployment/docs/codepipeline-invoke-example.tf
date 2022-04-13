resource "aws_iam_role" "codepipeline_invoke" {
  name        = "codepipeline-invoke"
  path        = "/"
  description = "Allows CloudWatch events to invoke CodePipeline"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = var.common_tags
}

resource "aws_iam_role_policy" "codepipeline_invoke" {
  name = "codepipeline-invoke"
  role = aws_iam_role.codepipeline_invoke.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": "codepipeline:StartPipelineExecution",
          "Resource": "*"
      }
  ]
}
POLICY
}
