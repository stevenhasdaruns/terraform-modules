variable "ami_owners" {
  description = "List of owners for source ECS AMI."
  type        = list
  default     = ["amazon"] # 591542846629
}

variable "bid_percentage" {
  description = "Integer of minimum percentage that a Spot Instance price must be when compared to on demand.  Example: A value of 20 would require the spot price be lower than 20% the current on demand price."
  type        = string
  default     = "100" # 100% of on demand price.  The module still requires this value when the compute type is not SPOT.
}

variable "compute_type" {
  description = "EC2 or SPOT."
  type        = string
  default     = "EC2"
}

variable "custom_ami" {
  description = "Optional string for custom AMI.  If omitted, latest ECS AMI in the current region will be used."
  type        = string
  default     = ""
}

variable "docker_expand_volume" {
  description = "Optionally expand docker volume.  AWS default is 10GB, some containers may require more storage."
  type        = bool
  default     = false
}

variable "docker_max_container_size" {
  description = "If docker_expand_volume is true, containers will allocate this amount of storage (GB) when launched."
  type        = number
  default     = 20
}

variable "ec2_key_pair" {
  description = "Optional keypair to connect to the instance with.  Consider SSM as an alternative."
  type        = string
  default     = ""
}

variable "efs_file_system_id" {
  description = "Optional EFS file system ID to mount on the EC2 instance.  Mounted on /efs."
  type        = string
  default     = ""
}

variable "instance_profile_arn" {
  description = "ARN of the EC2 instance profile for compute instances."
  type        = string
}

variable "instance_types" {
  description = "Optional list of instance types."
  type        = list
  default     = ["optimal"]
}


variable "scratch_volume_enabled" {
  description = "Create additional EBS volume for scratch space."
  type        = bool
  default     = false
}

variable "scratch_volume_device_name" {
  description = "Device name for scratch space volume - E.g. /dev/xvdf"
  type        = string
  default     = "/dev/xvdf"
}

variable "scratch_volume_ebs_size" {
  description = "Size in GB of scratch space volume."
  type        = number
  default     = 100
}

variable "scratch_volume_mount_point" {
  description = "Directory to mount additional volume - E.g. /scratch"
  type        = string
  default     = "/scratch"
}

variable "max_vcpus" {
  description = "Max vCPUs.  Default 2 for m4.large."
  type        = string
  default     = 8
}

variable "min_vcpus" {
  description = "Minimum vCPUs.  > 0 causes instances to always be running."
  type        = string
  default     = 0
}

variable "name" {
  description = "Compute environment name."
  type        = string
}

variable "security_group_ids" {
  description = "List of additional security groups to associate with cluster instances.  If empty, default security group will be added."
  default     = [""]
  type        = list
}

variable "service_role_batch_arn" {
  description = "ARN of the batch service role."
  type        = string
}

variable "service_role_spot_fleet_arn" {
  description = "ARN of the spot fleet service role."
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "List of subnets compute environment instances will be deployed in."
  type        = list
}

variable "tags" {
  description = "Tags to apply to all module resources."
  default     = {}
  type        = map
}

variable "type" {
  description = "MANAGED or UNMANAGED."
  type        = string
  default     = "MANAGED"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
