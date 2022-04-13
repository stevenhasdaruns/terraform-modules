data "aws_region" "this" {}
data "aws_caller_identity" "this" {}
data "aws_availability_zones" "this" {}

locals {
  region     = data.aws_region.this.name
  account_id = data.aws_caller_identity.this.account_id
  tags = {
    "Terraform" = "yes"
  }
  cluster_roles_mapping = [for r in var.cluster_admin_aws_roles : {
    username = "eks-admin"
    rolearn  = "arn:aws:iam::${local.account_id}:role/${r}"
    groups   = ["system:masters"]
  }]

  cluster_users_mapping = [for r in var.cluster_admin_aws_users : {
    username = "eks-admin"
    userarn  = "arn:aws:iam::${local.account_id}:user/${r}"
    groups   = ["system:masters"]
  }]

  node_security_group_id = var.nodes_create_security_group ? aws_security_group.nodes[0].id : ""
}
