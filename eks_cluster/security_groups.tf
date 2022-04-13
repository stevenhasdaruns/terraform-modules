# Security Group
resource "aws_security_group" "nodes" {
  count       = var.nodes_create_security_group ? 1 : 0
  name        = "${var.cluster_name}-nodes-sg"
  vpc_id      = var.vpc_id
  description = "EKS Managed Nodes Security Group"
  dynamic "ingress" {
    for_each = var.node_ingress_security_groups
    content {
      from_port       = ingress.value["port"]
      to_port         = ingress.value["port"]
      protocol        = "tcp"
      security_groups = [ingress.value["id"]]
    }
  }
  dynamic "ingress" {
    for_each = var.node_ingress_cidr_blocks
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = "tcp"
      cidr_blocks = [ingress.value["cidr"]]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = var.cluster_name
    Environment = var.env
    Terraform   = "yes"
    CreatedBy   = "MissionCloud"
  }
  lifecycle {
    ignore_changes = [description]
  }
}
