resource "aws_ecs_cluster" "cluster" {
  name = var.name
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "tasks" {
  name              = "${var.log_group_prefix}${var.name}/tasks"
  retention_in_days = var.log_group_retention
  tags              = var.tags
}

resource "aws_security_group" "sg" {
  name        = "ecs-${var.name}"
  description = "Controls access to ${var.name} ECS auto scaling group"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { "Name" = "ecs-${var.name}" })
}

resource "aws_security_group_rule" "egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "full egress"

  security_group_id = aws_security_group.sg.id
}

resource "aws_launch_configuration" "config" {
  name_prefix          = var.name
  image_id             = var.image_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ecs.name
  security_groups      = concat(var.security_group_ids, tolist([aws_security_group.sg.id]))

  root_block_device {
    volume_size = var.root_volume_size
    encrypted   = var.enable_ebs_encryption
  }

  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y aws-cli awslogs
echo "ECS_CLUSTER=${var.name}" >> /etc/ecs/ecs.config
echo "ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=1h" >> /etc/ecs/ecs.config
# AWS SSM Agent
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
# AWS Logs Agent
wget https://s3.amazonaws.com/privo-public-configuration/awslogs/amazon-linux/ecs-awslogs.conf -O /etc/awslogs/awslogs.conf
chkconfig awslogs on
service awslogs restart
# Support task roles while limiting access to node role
yum install -y iptables-services
iptables --insert FORWARD 1 --in-interface docker+ --destination 169.254.169.254/32 --jump DROP
service iptables save
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = var.name
  launch_configuration = aws_launch_configuration.config.name
  vpc_zone_identifier  = flatten(var.subnet_ids)
  min_size             = var.min_instances
  max_size             = var.max_instances
  desired_capacity     = var.desired_instances

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}
