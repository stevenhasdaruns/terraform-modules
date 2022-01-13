variable "name" {
  description = "Name used for cluster, IAM role, and security group."
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster version"
  default     = "1.15"
  type        = string
}

variable "cluster_endpoint_private_access" {
  description = "Limit cluster API access to internal network only"
  default     = true
  type        = bool
}

variable "cluster_endpoint_public_access" {
  description = "Allow public internet API access to cluster API"
  default     = false
  type        = bool
}

variable "cluster_log_retention" {
  description = "Cluster's CloudWatch log group retention in days.  Cluster logs must be enabled."
  default     = 7
  type        = number
}

variable "cluster_enabled_log_types" {
  description = "Control plane logging.  Empty list disables.  List containing any/all of the following enables: api, audit, authenticator, controllerManager, scheduler"
  default     = []
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnets IDs to for cluster deployment"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all stack resources"
  default     = {}
  type        = map
}

variable "vpc_id" {
  description = "Target VPC ID"
  type        = string
}

variable "worker_security_group_id" {
  description = "Security group ID attached to the EKS worker nodes"
  type        = string
}
