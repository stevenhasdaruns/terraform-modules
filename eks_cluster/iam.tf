# ExternalSecrets Policy
data "aws_iam_policy_document" "external_secrets" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetResourcePolicy", "secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret", "secretsmanager:ListSecretVersionIds"]
    resources = ["arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:*"]
  }
}

resource "aws_iam_policy" "external_secrets" {
  count  = var.create_external_secrets_role ? 1 : 0
  name   = "AmazonEKSExternalSecretsPolicy_${var.cluster_name}"
  policy = data.aws_iam_policy_document.external_secrets.json
}

module "external_secrets_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 2.0"
  create_role                   = true
  role_name                     = "AmazonEKSExternalSecrets_${var.cluster_name}"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.external_secrets[0].arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:external-secrets:external-secrets", "system:serviceaccount:kube-system:external-secrets"]
}
# Cluster Autoscaler Policy
data "aws_iam_policy_document" "cluster_autoscaling" {
  statement {
    effect    = "Allow"
    actions   = ["autoscaling:DescribeAutoScalingGroups", "autoscaling:DescribeAutoScalingInstances", "autoscaling:DescribeLaunchConfigurations", "autoscaling:DescribeTags", "autoscaling:SetDesiredCapacity", "autoscaling:TerminateInstanceInAutoScalingGroup", "ec2:DescribeLaunchTemplateVersions"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cluster_autoscaling" {
  count  = var.create_cluster_autoscaling_role ? 1 : 0
  name   = "AmazonEKSClusterAutoscalingPolicy_${var.cluster_name}"
  policy = data.aws_iam_policy_document.cluster_autoscaling.json
}

# Game Metadata Role
module "cluster_autoscaling_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 2.0"
  create_role                   = true
  role_name                     = "AmazonEKSClusterAutoscaling_${var.cluster_name}"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.cluster_autoscaling[0].arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:cluster-autoscaler", "system:serviceaccount:kube-system:*"]
}

# ExternalDNS Policy
data "aws_iam_policy_document" "external_dns" {
  statement {
    effect    = "Allow"
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["route53:ListHostedZones", "route53:ListResourceRecordSets"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "external_dns" {
  count  = var.create_externaldns_role ? 1 : 0
  name   = "AmazonEKSExternalDNSPolicy_${var.cluster_name}"
  policy = data.aws_iam_policy_document.external_dns.json
}

# ExternalDNS Role
module "external_dns_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 2.0"
  create_role                   = true
  role_name                     = "AmazonEKSExternalDNS_${var.cluster_name}"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.external_dns[0].arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:external-dns:external-dns"]
}

data "aws_iam_policy_document" "velero" {
  # these permissions are pull from https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/main/README.md
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.velero_bucket[0].id}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.velero_bucket[0].id}"
    ]
  }
}

resource "aws_iam_policy" "velero" {
  count  = var.create_velero_role ? 1 : 0
  name   = "AmazonEKSVelero_${var.cluster_name}"
  policy = data.aws_iam_policy_document.velero.json
}

module "velero_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 2.0"
  create_role                   = true
  role_name                     = "AmazonEKSVelero_${var.cluster_name}"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.velero[0].arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:velero:velero", "system:serviceaccount:kube-system:velero"]
}

# Cert-manager Policy
data "aws_iam_policy_document" "cert_manager" {
  statement {
    effect    = "Allow"
    actions   = ["route53:GetChange"]
    resources = ["arn:aws:route53:::change/*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["route53:ChangeResourceRecordSets", "route53:ListResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["route53:ListHostedZonesByName"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cert_manager" {
  count  = var.create_certmanager_role ? 1 : 0
  name   = "AmazonEKSCertManagerValidationPolicy_${var.cluster_name}"
  policy = data.aws_iam_policy_document.cert_manager.json
}

# Cert-manager Role
module "cert_manager_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 2.0"
  create_role                   = true
  role_name                     = "AmazonEKSCertManagerValidation_${var.cluster_name}"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.cert_manager[0].arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:cert-manager:cert-manager"]
}

#Node Role
resource "aws_iam_role" "node" {
  name_prefix        = "${var.cluster_name}-nodes"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "sts:AssumeRole",
          "Principal": {
              "Service": [
                "ec2.amazonaws.com"
              ]
          },
          "Effect": "Allow"
      }
  ]
}
EOF
}

# IAM Role Policy
data "aws_iam_policy_document" "node" {
  statement {
    effect = "Allow"
    actions = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents", "logs:DescribeLogGroups", "logs:DescribeLogStreams", "cloudwatch:PutMetricData", "autoscaling:DescribeAutoScalingGroups", "autoscaling:DescribeAutoScalingInstances",
    "autoscaling:DescribeLaunchConfigurations", "autoscaling:DescribeTags", "autoscaling:SetDesiredCapacity", "autoscaling:TerminateInstanceInAutoScalingGroup", "ec2:DescribeLaunchTemplateVersions"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "node" {
  name   = "${var.env}-Managed-Node-Policy"
  role   = aws_iam_role.node.name
  policy = data.aws_iam_policy_document.node.json
}

resource "aws_iam_role_policy_attachment" "node_ssm" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "node_insights" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "node_worker" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_cni" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_ecr" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "node_vpc" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}