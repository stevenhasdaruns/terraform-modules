data "aws_subnet" "parent_vpc" {
  id = var.subnet_ids[0]
}

resource "aws_efs_file_system" "fs" {
  encrypted                       = var.kms_key_arn != "NO_ENCRYPTION" ? true : false
  kms_key_id                      = var.kms_key_arn != "NO_ENCRYPTION" ? var.kms_key_arn : null
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.throughput_mode == "bursting" ? 0 : var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode

  dynamic "lifecycle_policy" {
    for_each = var.lifecycle_policy != "" ? ["create"] : []
    content {
      transition_to_ia = var.lifecycle_policy
    }
  }

  tags = merge(var.tags, { "Name" = var.name })
}

resource "aws_efs_mount_target" "mt" {
  for_each        = toset(var.subnet_ids)
  file_system_id  = aws_efs_file_system.fs.id
  subnet_id       = each.key
  security_groups = concat(var.security_group_ids, [aws_security_group.default.id])
}

resource "aws_security_group" "default" {
  name_prefix = "${var.name}-"
  description = "EFS"
  vpc_id      = data.aws_subnet.parent_vpc.vpc_id

  tags = merge(var.tags, { "Name" = var.name })
}

resource "aws_security_group_rule" "ingress_efs" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = var.ingress_cidrs
  security_group_id = aws_security_group.default.id
  description       = "EFS"
}
