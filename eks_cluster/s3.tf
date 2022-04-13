resource "aws_s3_bucket" "velero_bucket" {
  count = var.enable_velero ? 1 : 0
  #checkov:skip=CKV_AWS_18:Bypassing access logging for Velero bucket

  bucket = "velero-backup-${local.account_id}"
  # region cannot be set here and needs to come from the provider block
  acl = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "velero_bucket" {
  count                   = var.enable_velero ? 1 : 0
  bucket                  = aws_s3_bucket.velero_bucket[0].bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}