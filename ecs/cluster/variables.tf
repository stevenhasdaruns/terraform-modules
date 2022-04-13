variable "enable_ebs_encryption" {
  description = "Enable EBS encryption on the cluster instances"
  default     = true
  type        = bool
}

variable "image_id" {
  description = "AMI to use for ECS instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  default     = "t3a.small"
  type        = string
}

variable "key_name" {
  description = "Key Pair for instance access"
  type        = string
}

variable "log_group_prefix" {
  description = "Cloudwatch log group for ECS.  Combined with the cluster name.  Requires trailing slash."
  default     = "/aws/ecs/"
  type        = string
}

variable "log_group_retention" {
  description = "Cloudwatch log group retention in days"
  default     = 7
  type        = number
}

variable "name" {
  description = "Cluster name"
  type        = string
}

variable "min_instances" {
  description = "Min number of instances. Default is 0."
  default     = 0
  type        = number
}

variable "max_instances" {
  description = "Max number of instances. Default is 0."
  default     = 0
  type        = number
}

variable "desired_instances" {
  description = "Number of instances to launch. Default is 0."
  default     = 0
  type        = number
}

variable "root_volume_size" {
  description = "Root volume size for each instance. (Must be at least as big as the AMI volume.)"
  default     = 40
  type        = number
}

variable "security_group_ids" {
  description = "List of additional security groups to associate with cluster instances."
  default     = []
  type        = list(any)
}

variable "subnet_ids" {
  description = "List of subnets cluster instances will be deployed in."
  type        = list(any)
}

variable "tags" {
  description = "Tags to apply to all module resources."
  default     = {}
  type        = map(any)
}

variable "user_data" {
  description = "User data script to run at instance launch."
  default     = " " # cannot be an zero length string.
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
