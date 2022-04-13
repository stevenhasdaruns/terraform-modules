variable "env" {
  type        = string
  description = "Environment"
}

variable "manage_aws_auth" {
  description = "Manage AWS Auth - Create Configmap"
  default     = "true"
}

variable "cluster_admin_aws_roles" {
  description = "Additional IAM Roles Mapped to Cluster Admin"
  type        = list(string)
  default     = []
}

variable "cluster_admin_aws_users" {
  description = "Additional IAM Users Mapped to Cluster Admin"
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  type        = string
  description = "EKS Cluster Name"
}

variable "cluster_tags" {
  type        = map(string)
  default     = {}
  description = "EKS Cluster Tags"
}

variable "node_group_tags" {
  type        = list(map(string))
  default     = []
  description = "Node Group Tags"
}

variable "worker_group_tags" {
  type        = list(map(string))
  default     = []
  description = "Node Group Tags"
}

variable "cluster_version" {
  type        = number
  description = "EKS Cluster Version"
}

variable "enable_irsa" {
  default     = true
  description = "Enable IRSA"
  type        = bool
}

variable "deploy_role" {
  description = "Terraform Deploy Role"
  type        = string
}

variable "enable_container_insights" {
  description = "Install Container Insights"
  default     = "true"
}

variable "cluster_public_access_cidrs" {
  description = "Cluster Public Access CIDRs"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_endpoint_public_access" {
  description = "Cluster Endpoint Public Access"
  default     = "true"
}

variable "cluster_endpoint_private_access" {
  description = "Cluster Endpoint Private Access"
  default     = "true"
}

variable "key_name" {
  description = "Managed Node Group Keypair"
  type        = string
  default     = ""
}

variable "cluster_create_security_group" {
  description = "Create Cluster Security Group"
  default     = "true"
}

variable "nodes_create_security_group" {
  description = "Create Nodes Security Group"
  default     = "false"
  type        = bool
}

variable "node_ingress_security_groups" {
  type    = list(map(string))
  default = []
}

variable "node_ingress_cidr_blocks" {
  type    = list(map(string))
  default = []
}

variable "cluster_autoscaler_enabled" {
  description = "K8s Cluster Autoscaler Enabled"
  default     = "false"
  type        = string
}

variable "cluster_autoscaler_repository" {
  description = "K8s Cluster Autoscaler Repository URL"
  default     = "us.gcr.io/k8s-artifacts-prod/autoscaling/cluster-autoscaler"
  type        = string
}
variable "cluster_autoscaler_tag" {
  description = "K8s Cluster Autoscaler Repository Tag"
  default     = "v1.15.6"
  type        = string
}

variable "cluster_endpoint_private_access_cidrs" {
  description = "List of Cluster Endpoint Private Access CIDRs"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "worker_groups" {
  description = "A list of maps defining worker group configurations to be defined using AWS Launch Configurations. See workers_group_defaults for valid keys."
  type        = any
  default     = []
}

variable "workers_group_defaults" {
  description = "Override default values for target groups. See workers_group_defaults_defaults in local.tf for valid keys."
  type        = any
  default     = {}
}

variable "node_groups_defaults" {
  description = "Map of values to be applied to all node groups. See `node_groups` module's documentaton for more details"
  type        = any
  default     = {}
}

variable "node_groups" {
  description = "Map of map of node groups to create. See `node_groups` module's documentation for more details"
  type        = any
  default     = {}
}

variable "private_subnets" {
  type        = list(string)
  description = "Private Subnets"
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "externaldns_lookup_zone" {
  description = "Name of the Route53 Hosted Zone"
}

variable "enable_externaldns" {
  description = "Install externaldns"
  default     = "true"
}

variable "enable_nginx_ingress" {
  description = "Install nginx-ingress"
  default     = "true"
}

variable "enable_cert_manager" {
  description = "Install cert-manager"
  default     = "true"
}

variable "enable_cluster_autoscaler" {
  description = "Install cluster-autoscaler"
  default     = "false"
}

variable "enable_prometheus" {
  description = "Install prometheus"
  default     = "true"
}

variable "enable_grafana" {
  description = "Install grafana"
  default     = "true"
}

variable "enable_efs_provisioner" {
  description = "Install EFS Provisioner"
  default     = "true"
}
variable "enable_external_secrets" {
  description = "Install ExternalSecrets"
  default     = "true"
}

variable "enable_fluentd" {
  description = "Install fluentd for ES logging"
  default     = "true"
}

variable "enable_velero" {
  description = "Install Velero and create required resources"
  default     = "true"
}

variable "efs_fs_id" {
  description = "EFS Filesystem ID"
}

variable "workers_additional_policies" {
  description = "Additional policies to be added to workers"
  type        = list(string)
  default     = []
}

variable "create_externaldns_role" {
  description = "Create the ExternalDNS IAM Role"
  type        = bool
  default     = true
}

variable "create_external_secrets_role" {
  description = "Create the ExternalSecrets IAM Role"
  type        = bool
  default     = true
}

variable "create_certmanager_role" {
  description = "Create the ExternalDNS IAM Role"
  type        = bool
  default     = true
}
variable "create_cluster_autoscaling_role" {
  description = "Create the Cluster Autoscaling IAM Role"
  type        = bool
  default     = true
}

variable "create_velero_role" {
  description = "Create the Velero IAM Role"
  type        = bool
  default     = true
}