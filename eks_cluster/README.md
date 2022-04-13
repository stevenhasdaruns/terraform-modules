### Current version tag is 2.1.0

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.9 |
| kubernetes | ~> 1.9 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| helm | n/a |
| kubectl | n/a |
| kubernetes | n/a |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.27 |
| helm | ~> 2.0.0 |
| kubernetes | ~> 1.11 |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_admin\_aws\_roles | Additional IAM Roles Mapped to Cluster Admin | `list(string)` | `[]` | no |
| cluster\_admin\_aws\_users | Additional IAM Users Mapped to Cluster Admin | `list(string)` | `[]` | no |
| cluster\_autoscaler\_enabled | K8s Cluster Autoscaler Enabled | `string` | `"false"` | no |
| cluster\_autoscaler\_repository | K8s Cluster Autoscaler Repository URL | `string` | `"us.gcr.io/k8s-artifacts-prod/autoscaling/cluster-autoscaler"` | no |
| cluster\_autoscaler\_tag | K8s Cluster Autoscaler Repository Tag | `string` | `"v1.15.6"` | no |
| cluster\_create\_security\_group | Create Cluster Security Group | `string` | `"true"` | no |
| cluster\_endpoint\_private\_access | Cluster Endpoint Private Access | `string` | `"true"` | no |
| cluster\_endpoint\_private\_access\_cidrs | List of Cluster Endpoint Private Access CIDRs | `any` | n/a | yes |
| cluster\_endpoint\_public\_access | Cluster Endpoint Public Access | `string` | `"true"` | no |
| cluster\_name | EKS Cluster Name | `string` | n/a | yes |
| cluster\_public\_access\_cidrs | Cluster Public Access CIDRs | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| cluster\_tags | EKS Cluster Tags | `map(string)` | `{}` | no |
| cluster\_version | EKS Cluster Version | `number` | n/a | yes |
| create\_certmanager\_role | Create the ExternalDNS IAM Role | `bool` | `true` | no |
| create\_externaldns\_role | Create the ExternalDNS IAM Role | `bool` | `true` | no |
| create\_game\_metadata\_role | Create the Game Metadata IAM Role | `bool` | `true` | no |
| create\_sqs\_role | Create the SQS Pod IAM Role | `bool` | `true` | no |
| deploy\_role | Terraform Deploy Role | `string` | n/a | yes |
| efs\_fs\_id | EFS Filesystem ID | `any` | n/a | yes |
| enable\_cert\_manager | Install cert-manager | `string` | `"true"` | no |
| enable\_cluster\_autoscaler | Install cluster-autoscaler | `string` | `"false"` | no |
| enable\_efs\_provisioner | Install EFS Provisioner | `string` | `"true"` | no |
| enable\_externaldns | Install externaldns | `string` | `"true"` | no |
| enable\_fluentd | Install fluentd for ES logging | `string` | `"true"` | no |
| enable\_grafana | Install grafana | `string` | `"true"` | no |
| enable\_irsa | Enable IRSA | `bool` | `true` | no |
| enable\_nginx\_ingress | Install nginx-ingress | `string` | `"true"` | no |
| enable\_prometheus | Install prometheus | `string` | `"true"` | no |
| env | Environment | `string` | n/a | yes |
| externaldns\_lookup\_zone | Name of the Route53 Hosted Zone | `any` | n/a | yes |
| key\_name | Managed Node Group Keypair | `string` | `""` | no |
| manage\_aws\_auth | Manage AWS Auth - Create Configmap | `string` | `"true"` | no |
| node\_group\_tags | Node Group Tags | `list(map(string))` | `[]` | no |
| node\_groups | Map of map of node groups to create. See `node_groups` module's documentation for more details | `any` | `{}` | no |
| node\_groups\_defaults | Map of values to be applied to all node groups. See `node_groups` module's documentaton for more details | `any` | `{}` | no |
| node\_ingress\_cidr\_blocks | n/a | `list(map(string))` | `[]` | no |
| node\_ingress\_security\_groups | n/a | `list(map(string))` | `[]` | no |
| nodes\_create\_security\_group | Create Nodes Security Group | `bool` | `"false"` | no |
| private\_subnets | Private Subnets | `list(string)` | `[]` | no |
| tags | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| vpc\_id | VPC ID | `any` | n/a | yes |
| worker\_group\_tags | Node Group Tags | `list(map(string))` | `[]` | no |
| worker\_groups | A list of maps defining worker group configurations to be defined using AWS Launch Configurations. See workers\_group\_defaults for valid keys. | `any` | `[]` | no |
| workers\_additional\_policies | Additional policies to be added to workers | `list(string)` | `[]` | no |
| workers\_group\_defaults | Override default values for target groups. See workers\_group\_defaults\_defaults in local.tf for valid keys. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudwatch\_log\_group\_name | Name of cloudwatch log group created |
| cluster\_arn | The Amazon Resource Name (ARN) of the cluster. |
| cluster\_certificate\_authority\_data | Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster. |
| cluster\_endpoint | The endpoint for your EKS Kubernetes API. |
| cluster\_iam\_role\_arn | IAM role ARN of the EKS cluster. |
| cluster\_iam\_role\_name | IAM role name of the EKS cluster. |
| cluster\_id | The name/id of the EKS cluster. |
| cluster\_oidc\_issuer\_url | The URL on the EKS cluster OIDC Issuer |
| cluster\_security\_group\_id | Security group ID attached to the EKS cluster. On 1.14 or later, this is the 'Additional security groups' in the EKS console. |
| cluster\_version | The Kubernetes server version for the EKS cluster. |
| node\_groups | Outputs from EKS node groups. Map of maps, keyed by var.node\_groups keys |
| oidc\_provider\_arn | The ARN of the OIDC Provider if `enable_irsa = true`. |
| worker\_iam\_instance\_profile\_arns | default IAM instance profile ARN for EKS worker groups |
| worker\_iam\_instance\_profile\_names | default IAM instance profile name for EKS worker groups |
| worker\_iam\_role\_arn | default IAM role ARN for EKS worker groups |
| worker\_iam\_role\_name | default IAM role name for EKS worker groups |
| worker\_security\_group\_id | Security group ID attached to the EKS workers. |
| workers\_asg\_arns | IDs of the autoscaling groups containing workers. |
| workers\_asg\_names | Names of the autoscaling groups containing workers. |
| workers\_default\_ami\_id | ID of the default worker group AMI |
| workers\_launch\_template\_latest\_versions | Latest versions of the worker launch templates. |
| workers\_user\_data | User data of worker groups |

### Module call
```hcl
  module "eks" {
  source = "git@github.com:fortelabsinc/terraform-importable-modules.git//eks_cluster?ref=EKSv2.1.0"
  cluster_name                          = local.prefix_env
  cluster_version                       = "1.15"
  vpc_id                                = module.vpc.vpc_id
  private_subnets                       = flatten([module.vpc.private_subnets])
  env                                   = local.prefix_env
  deploy_role                           = "arn:aws:iam::984475896453:role/MissionAdministrator"
  cluster_admin_aws_roles               = ["MissionAdministrator", "eks-mgmt"]
  cluster_admin_aws_users               = ["ghoffer", "devops"]
  key_name                              = "forte-dev-key"
  cluster_endpoint_private_access_cidrs = [module.vpc.vpc_cidr_block]
  cluster_public_access_cidrs           = ["0.0.0.0/0"]
  cluster_create_security_group         = true
  enable_irsa                           = true
  tags = {
    environment                                 = local.prefix_env
    "kubernetes.io/cluster/${local.prefix_env}" = "shared"
    "k8s.io/cluster-autoscaler/enabled"         = "true"
  }

  workers_additional_policies = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy", "arn:aws:iam::984475896453:policy/ClusterAutoscale", "arn:aws:iam::984475896453:policy/S3-full"]

  workers_group_defaults = {
    instance_type                 = "m5.2xlarge"
    asg_min_size                  = 1
    asg_max_size                  = 1
    asg_desired_capacity          = 1
    key_name                      = "forte-dev-key"
    additional_security_group_ids = module.security_groups.sg_internal
    autoscaling_enabled           = "false"
    additional_userdata           = <<EOF
      echo 'LimitMEMLOCK=infinity' >> /usr/lib/systemd/system/docker.service
      sudo systemctl daemon-reload
      sudo systemctl restart docker.service
EOF
  }
  
  worker_groups = [
    {
      instance_type        = "m5.2xlarge"
      asg_min_size         = 5
      asg_max_size         = 5
      asg_desired_capacity = 5
      kubelet_extra_args   = "--node-labels=node-affinity=main,nodegroup=main"
      tags                 = [for k, v in { "kubernetes.io/cluster/${local.prefix_env}" = "shared", "k8s.io/cluster-autoscaler/enabled" = "true", "k8s.io/cluster-autoscaler/${local.prefix_env}" = "true", "k8s.io/cluster-autoscaler/node-template/label/node-affinity" = "main", "k8s.io/cluster-autoscaler/node-template/label/nodegroup" = "main" } : { key = k, value = v, propagate_at_launch = true }]
    },
    {
      instance_type        = "m5.2xlarge"
      asg_min_size         = 1
      asg_max_size         = 2
      asg_desired_capacity = 1
      kubelet_extra_args   = "--node-labels=node-affinity=networking,nodegroup=networking"
      tags                 = [for k, v in { "kubernetes.io/cluster/${local.prefix_env}" = "shared", "k8s.io/cluster-autoscaler/enabled" = "true", "k8s.io/cluster-autoscaler/${local.prefix_env}" = "true", "k8s.io/cluster-autoscaler/node-template/label/node-affinity" = "networking", "k8s.io/cluster-autoscaler/node-template/label/nodegroup" = "networking" } : { key = k, value = v, propagate_at_launch = true }]
    },
    {
      instance_type        = "m5.2xlarge"
      asg_min_size         = 0
      asg_max_size         = 3
      asg_desired_capacity = 0
      name                 = "forte-chains"
      kubelet_extra_args = join(" ", [
        "--node-labels=node-affinity=forte-chains,nodegroup=forte-chains",
        "--register-with-taints forte-chains=true:NoSchedule"
      ])
      tags = [for k, v in { "kubernetes.io/cluster/${local.prefix_env}" = "shared", "k8s.io/cluster-autoscaler/enabled" = "true", "k8s.io/cluster-autoscaler/${local.prefix_env}" = "true", "k8s.io/cluster-autoscaler/node-template/label/node-affinity" = "forte-chains", "k8s.io/cluster-autoscaler/node-template/label/nodegroup" = "forte-chains", "k8s.io/cluster-autoscaler/node-template/taint/forte-chains" = "true:NoSchedule" } : { key = k, value = v, propagate_at_launch = true }]
    },
    {
      instance_type        = "m5.2xlarge"
      asg_min_size         = 0
      asg_max_size         = 3
      asg_desired_capacity = 0
      name                 = "forte-clients"
      kubelet_extra_args = join(" ", [
        "--node-labels=node-affinity=forte-clients,nodegroup=forte-clients",
        "--register-with-taints forte-clients=true:NoSchedule"
      ])
      tags = [for k, v in { "kubernetes.io/cluster/${local.prefix_env}" = "shared", "k8s.io/cluster-autoscaler/enabled" = "true", "k8s.io/cluster-autoscaler/${local.prefix_env}" = "true", "k8s.io/cluster-autoscaler/node-template/label/node-affinity" = "forte-clients", "k8s.io/cluster-autoscaler/node-template/label/nodegroup" = "forte-clients", "k8s.io/cluster-autoscaler/node-template/taint/forte-clients" = "true:NoSchedule" } : { key = k, value = v, propagate_at_launch = true }]
    },
    {
      instance_type        = "m5.4xlarge"
      asg_min_size         = 3
      asg_max_size         = 6
      asg_desired_capacity = 6
      kubelet_extra_args = join(" ", [
        "--node-labels=node-affinity=chains,nodegroup=chains",
        "--register-with-taints chains=true:NoSchedule"
      ])
      tags = [for k, v in { "kubernetes.io/cluster/${local.prefix_env}" = "shared", "k8s.io/cluster-autoscaler/enabled" = "true", "k8s.io/cluster-autoscaler/${local.prefix_env}" = "true", "k8s.io/cluster-autoscaler/node-template/label/node-affinity" = "chains", "k8s.io/cluster-autoscaler/node-template/label/nodegroup" = "chains", "k8s.io/cluster-autoscaler/node-template/taint/chains" = "true:NoSchedule" } : { key = k, value = v, propagate_at_launch = true }]
    },
    {
      instance_type        = "m5.4xlarge"
      asg_min_size         = 0
      asg_max_size         = 6
      asg_desired_capacity = 0
      name                 = "l-game-chains"
      kubelet_extra_args = join(" ", [
        "--node-labels=node-affinity=l-game-chains,nodegroup=l-game-chains",
        "--register-with-taints l-game-chains=true:NoSchedule"
      ])
      tags = [for k, v in { "kubernetes.io/cluster/${local.prefix_env}" = "shared", "k8s.io/cluster-autoscaler/enabled" = "true", "k8s.io/cluster-autoscaler/${local.prefix_env}" = "true", "k8s.io/cluster-autoscaler/node-template/label/node-affinity" = "l-game-chains", "k8s.io/cluster-autoscaler/node-template/label/nodegroup" = "l-game-chains", "k8s.io/cluster-autoscaler/node-template/taint/l-game-chains" = "true:NoSchedule" } : { key = k, value = v, propagate_at_launch = true }]
    },
    {
      instance_type        = "m5.4xlarge"
      asg_min_size         = 0
      asg_max_size         = 3
      asg_desired_capacity = 0
      name                 = "l-game-clients"
      kubelet_extra_args = join(" ", [
        "--node-labels=node-affinity=l-game-clients,nodegroup=l-game-clients",
        "--register-with-taints l-game-clients=true:NoSchedule"
      ])
      tags = [for k, v in { "kubernetes.io/cluster/${local.prefix_env}" = "shared", "k8s.io/cluster-autoscaler/enabled" = "true", "k8s.io/cluster-autoscaler/${local.prefix_env}" = "true", "k8s.io/cluster-autoscaler/node-template/label/node-affinity" = "l-game-clients", "k8s.io/cluster-autoscaler/node-template/label/nodegroup" = "l-game-clients", "k8s.io/cluster-autoscaler/node-template/taint/l-game-clients" = "true:NoSchedule" } : { key = k, value = v, propagate_at_launch = true }]
    },
    {
      instance_type        = "m5.2xlarge"
      asg_min_size         = 0
      asg_max_size         = 3
      asg_desired_capacity = 0
      name                 = "s-game-chains"
      kubelet_extra_args = join(" ", [
        "--node-labels=node-affinity=s-game-chains,nodegroup=s-game-chains",
        "--register-with-taints s-game-chains=true:NoSchedule"
      ])
      tags = [for k, v in { "kubernetes.io/cluster/${local.prefix_env}" = "shared", "k8s.io/cluster-autoscaler/enabled" = "true", "k8s.io/cluster-autoscaler/${local.prefix_env}" = "true", "k8s.io/cluster-autoscaler/node-template/label/node-affinity" = "s-game-chains", "k8s.io/cluster-autoscaler/node-template/label/nodegroup" = "s-game-chains", "k8s.io/cluster-autoscaler/node-template/taint/s-game-chains" = "true:NoSchedule" } : { key = k, value = v, propagate_at_launch = true }]
    },
    {
      instance_type        = "m5.2xlarge"
      asg_min_size         = 0
      asg_max_size         = 3
      asg_desired_capacity = 0
      name                 = "s-game-clients"
      kubelet_extra_args = join(" ", [
        "--node-labels=node-affinity=s-game-clients,nodegroup=s-game-clients",
        "--register-with-taints s-game-clients=true:NoSchedule"
      ])
      tags = [for k, v in { "kubernetes.io/cluster/${local.prefix_env}" = "shared", "k8s.io/cluster-autoscaler/enabled" = "true", "k8s.io/cluster-autoscaler/${local.prefix_env}" = "true", "k8s.io/cluster-autoscaler/node-template/label/node-affinity" = "s-game-clients", "k8s.io/cluster-autoscaler/node-template/label/nodegroup" = "s-game-clients", "k8s.io/cluster-autoscaler/node-template/taint/s-game-clients" = "true:NoSchedule" } : { key = k, value = v, propagate_at_launch = true }]
    },
    {
      instance_type        = "m5.4xlarge"
      asg_min_size         = 0
      asg_max_size         = 6
      asg_desired_capacity = 0
      name                 = "game-chains-clients"
      kubelet_extra_args = join(" ", [
        "--node-labels=node-affinity=game-chains-clients,nodegroup=game-chains-clients",
        "--register-with-taints game-chains-clients=true:NoSchedule"
      ])
      tags = [for k, v in { "kubernetes.io/cluster/${local.prefix_env}" = "shared", "k8s.io/cluster-autoscaler/enabled" = "true", "k8s.io/cluster-autoscaler/${local.prefix_env}" = "true", "k8s.io/cluster-autoscaler/node-template/label/node-affinity" = "game-chains-clients", "k8s.io/cluster-autoscaler/node-template/label/nodegroup" = "game-chains-clients", "k8s.io/cluster-autoscaler/node-template/taint/game-chains-clients" = "true:NoSchedule" } : { key = k, value = v, propagate_at_launch = true }]
    }
  ] 
  # Cluster config
  enable_externaldns        = true
  enable_nginx_ingress      = true
  enable_cert_manager       = true
  enable_cluster_autoscaler = false
  enable_prometheus         = true
  enable_grafana            = true
  enable_efs_provisioner    = true
  enable_fluentd            = true
  externaldns_lookup_zone   = module.dns_subzone.subzone_id
  efs_fs_id                 = module.efs.id
}
```