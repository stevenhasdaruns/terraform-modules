data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_region" "current" {}

provider "kubernetes" {
  host                   = element(concat(data.aws_eks_cluster.cluster[*].endpoint, list("")), 0)
  cluster_ca_certificate = base64decode(element(concat(data.aws_eks_cluster.cluster[*].certificate_authority.0.data, list("")), 0))
  token                  = element(concat(data.aws_eks_cluster_auth.cluster[*].token, list("")), 0)
  #load_config_file       = false
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 13.2.1"

  cluster_name                                 = var.cluster_name
  cluster_version                              = var.cluster_version
  subnets                                      = var.private_subnets
  enable_irsa                                  = var.enable_irsa
  cluster_endpoint_private_access              = var.cluster_endpoint_private_access
  cluster_endpoint_private_access_cidrs        = var.cluster_endpoint_private_access_cidrs
  cluster_endpoint_public_access               = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs         = var.cluster_public_access_cidrs
  cluster_enabled_log_types                    = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  kubeconfig_aws_authenticator_additional_args = ["-r", var.deploy_role]
  manage_aws_auth                              = var.manage_aws_auth
  tags                                         = merge(local.tags, var.cluster_tags)
  cluster_create_security_group                = var.cluster_create_security_group

  vpc_id           = var.vpc_id
  write_kubeconfig = true
  kubeconfig_name  = var.cluster_name

  node_groups = var.node_groups
  node_groups_defaults = merge(var.node_groups_defaults, {
    ami_type     = "AL2_x86_64"
    iam_role_arn = aws_iam_role.node.arn
    #source_security_group_ids                   = [local.node_security_group_id]
    tags = concat(
      [
        {
          "key"                 = "kubernetes.io/cluster/${var.cluster_name}"
          "value"               = "owned"
          "propagate_at_launch" = true
        },
        {
          "key"                 = "Name"
          "value"               = "${var.cluster_name}-managed-nodes"
          "propagate_at_launch" = true
        },
        {
          "key"                 = "k8s.io/cluster/${var.cluster_name}"
          "value"               = "owned"
          "propagate_at_launch" = true
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "value"               = var.cluster_autoscaler_enabled
          "propagate_at_launch" = true
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
          "value"               = "owned"
          "propagate_at_launch" = true
        },
      ],
      var.node_group_tags,
    )
  }, )

  worker_groups = var.worker_groups
  workers_group_defaults = merge(var.workers_group_defaults, {
    autoscaling_enabled = "true"
    additional_userdata = <<EOF
  echo never > /sys/kernel/mm/transparent_hugepage/enabled
  echo never > /sys/kernel/mm/transparent_hugepage/defrag
  echo 'LimitMEMLOCK=infinity' >> /usr/lib/systemd/system/docker.service
  sudo systemctl daemon-reload
  sudo systemctl restart docker.service
EOF
    tags = concat(
      [
        {
          "key"                 = "kubernetes.io/cluster/${var.cluster_name}"
          "value"               = "owned"
          "propagate_at_launch" = true
        },
        {
          "key"                 = "Name"
          "value"               = "${var.cluster_name}-worker-nodes"
          "propagate_at_launch" = true
        },
        {
          "key"                 = "k8s.io/cluster/${var.cluster_name}"
          "value"               = "owned"
          "propagate_at_launch" = true
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "value"               = var.cluster_autoscaler_enabled
          "propagate_at_launch" = true
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
          "value"               = "owned"
          "propagate_at_launch" = true
        },
      ],
      var.worker_group_tags,
    )
  }, )
  workers_additional_policies = var.workers_additional_policies

  map_roles = local.cluster_roles_mapping
  map_users = local.cluster_users_mapping
}


resource "local_file" "kubeconfig" {
  # HACK: depends_on for the helm provider
  # Passing provider configuration value via a local_file
  depends_on = [module.eks]
  content    = "kubeconfig_${var.cluster_name}"
  filename   = var.cluster_name

}

module "cluster_config" {
  source                        = "./modules/helm"
  enable_externaldns            = var.enable_externaldns
  enable_nginx_ingress          = var.enable_nginx_ingress
  enable_cert_manager           = var.enable_cert_manager
  enable_cluster_autoscaler     = var.enable_cluster_autoscaler
  enable_prometheus             = var.enable_prometheus
  enable_grafana                = var.enable_grafana
  enable_efs_provisioner        = var.enable_efs_provisioner
  enable_fluentd                = var.enable_fluentd
  enable_container_insights     = var.enable_container_insights
  enable_external_secrets       = var.enable_external_secrets
  enable_velero                 = var.enable_velero
  velero_bucket                 = var.enable_velero ? aws_s3_bucket.velero_bucket[0].id : ""
  velero_role_arn               = module.velero_role.this_iam_role_arn
  external_secrets_role_arn     = module.external_secrets_role.this_iam_role_arn
  externaldns_role_arn          = module.external_dns_role.this_iam_role_arn
  cert_manager_role_arn         = module.cert_manager_role.this_iam_role_arn
  externaldns_lookup_zone       = var.externaldns_lookup_zone
  cluster_name                  = var.cluster_name
  region                        = data.aws_region.current.name
  environment                   = var.env
  efs_fs_id                     = var.efs_fs_id
  cluster_autoscaler_repository = var.cluster_autoscaler_repository
  cluster_autoscaler_tag        = var.cluster_autoscaler_tag
  kubeconfig_path               = local_file.kubeconfig.id
  host                          = element(concat(data.aws_eks_cluster.cluster[*].endpoint, list("")), 0)
  cluster_ca_certificate        = base64decode(element(concat(data.aws_eks_cluster.cluster[*].certificate_authority.0.data, list("")), 0))
  token                         = element(concat(data.aws_eks_cluster_auth.cluster[*].token, list("")), 0)
  vpc_id                        = var.vpc_id
}
