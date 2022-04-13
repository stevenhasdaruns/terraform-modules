data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_security_group" "alb" {
  name        = "alb-${var.name}"
  description = "Controls access to ${var.name} ALB"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { "Name" = "alb-${var.name}" })
}

resource "aws_security_group_rule" "egress_tcp_full" {
  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Full TCP Egress"

  security_group_id = aws_security_group.alb.id
}

resource "aws_alb" "alb" {
  name                       = var.name
  internal                   = var.internal
  subnets                    = var.subnet_ids
  security_groups            = concat(var.security_group_ids, tolist([aws_security_group.alb.id]))
  idle_timeout               = var.idle_timeout
  enable_deletion_protection = var.enable_deletion_protection

  access_logs {
    bucket  = var.existing_log_bucket_name == "" ? aws_s3_bucket.s3[0].bucket : var.existing_log_bucket_name
    prefix  = var.name
    enabled = var.enable_access_logs
  }

  tags = var.tags
}

resource "aws_s3_bucket" "s3" {
  count  = var.existing_log_bucket_name == "" ? 1 : 0
  bucket = var.log_bucket_name == "" ? "alb-logs-${data.aws_caller_identity.current.account_id}-${var.name}" : var.log_bucket_name

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "expire_all_after_${var.log_expiration_days}_days"
    enabled = var.log_expiration

    expiration {
      days = var.log_expiration_days
    }
  }
}

resource "aws_s3_bucket_policy" "policy" {
  count  = var.existing_log_bucket_name == "" ? 1 : 0
  bucket = aws_s3_bucket.s3[0].id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.aws_alb_log_account[data.aws_region.current.name]}:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.s3[0].bucket}/*"
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket = var.log_bucket_name == "" ? "alb-logs-${data.aws_caller_identity.current.account_id}-${var.name}" : var.log_bucket_name

  block_public_acls       = var.s3_block_all_public_access
  block_public_policy     = var.s3_block_all_public_access
  ignore_public_acls      = var.s3_block_all_public_access
  restrict_public_buckets = var.s3_block_all_public_access
}
