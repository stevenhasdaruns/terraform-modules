data "aws_ami" "ecs_latest" {
  most_recent = true
  owners      = var.ami_owners

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_security_group" "default" {
  count = var.security_group_ids[0] == "" ? 1 : 0

  filter {
    name   = "group-name"
    values = ["default"]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_batch_compute_environment" "env" {
  compute_environment_name = var.name

  compute_resources {
    instance_role  = var.instance_profile_arn
    bid_percentage = var.bid_percentage

    launch_template {
      launch_template_id = aws_launch_template.batch.id
      version            = aws_launch_template.batch.latest_version # 2020/02 - Explicit because $Latest uses $Default
    }

    ec2_key_pair  = var.ec2_key_pair != "" ? var.ec2_key_pair : null
    instance_type = var.instance_types
    max_vcpus     = var.max_vcpus
    min_vcpus     = var.min_vcpus

    security_group_ids  = var.security_group_ids[0] == "" ? ["${data.aws_security_group.default[0].id}"] : var.security_group_ids
    spot_iam_fleet_role = var.compute_type == "SPOT" ? var.service_role_spot_fleet_arn : ""
    subnets             = var.subnet_ids
    tags                = merge(var.tags, { "Name" = var.name })
    type                = var.compute_type
  }

  service_role = var.service_role_batch_arn
  type         = var.type

  lifecycle {
    ignore_changes = [
      compute_resources[0].desired_vcpus
    ]
  }

}

data "template_file" "launch_template_user_data" {
  template = <<TEMPLATE
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
# This script is maintained via Terraform

# Install the AWS SSM agent to allow instance ingress
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

# Optional scratch volume used by task definitions
if ${var.scratch_volume_enabled}; then
  mkdir -p ${var.scratch_volume_mount_point}
  mkfs.ext4 ${var.scratch_volume_device_name}
  mount ${var.scratch_volume_device_name} ${var.scratch_volume_mount_point}
fi

# Expand individual docker storage if container requires more than defaul 10GB
if ${var.docker_expand_volume}; then
  cloud-init-per once docker_options echo 'OPTIONS="$$${OPTIONS} --storage-opt dm.basesize=${var.docker_max_container_size}G"' >> /etc/sysconfig/docker
  service docker restart
  docker restart ecs-agent
fi

if ${var.efs_file_system_id != "" ? true : false}; then
  yum install -y amazon-efs-utils
  mkdir -p /efs
  mount -t efs -o tls ${var.efs_file_system_id}:/ /efs
fi
--==MYBOUNDARY==--
TEMPLATE
}

resource "aws_launch_template" "batch" {
  name        = var.name
  description = "Used by Batch Compute Environment ${var.name}"

  image_id = var.custom_ami == "" ? data.aws_ami.ecs_latest.id : var.custom_ami

  dynamic "block_device_mappings" {
    for_each = var.scratch_volume_enabled ? ["create"] : []
    content {
      device_name = var.scratch_volume_device_name

      ebs {
        volume_size = var.scratch_volume_ebs_size
      }
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.tags, { "Name" = var.name })
  }

  user_data = base64encode(data.template_file.launch_template_user_data.rendered)
}
