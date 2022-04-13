variable "ami" {
  description = "Base Amazon Machine Image (AMI)"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address"
  default     = false
  type        = bool
}

variable "disable_api_termination" {
  description = "Prevent instances from being accidentally terminated"
  default     = true
  type        = bool
}

variable "ebs_block_device" {
  description = "List of maps containing additional EBS volumes"
  default     = []
  type        = list(map(string))
}

variable "iam_instance_profile" {
  description = "IAM instance profile *Name* associated with the IAM role to attach to the instance"
  default     = ""
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  default     = "t3a.small"
  type        = string
}

variable "key_name" {
  description = "Key Pair for instance access (key name, NOT key ID)"
  type        = string
}

variable "enable_detailed_monitoring" {
  description = "Detailed monitoring delivers 1 minute instance metrics for an extra cost.  Basic monitoring is 5 minutes."
  default     = false
  type        = bool
}

variable "private_ip" {
  description = "Optionally specify a specific private IP address"
  default     = ""
  type        = string
}

variable "root_block_device" {
  description = "Root EBS volume definition"
  type        = list(map(string))
}

variable "source_dest_check" {
  description = "Source and destination packet checks.  Disable only for NAT or VPN related instances."
  default     = true
  type        = bool
}

variable "subnet_id" {
  description = "Target subnet for instance deployment"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all module resources."
  default     = {}
  type        = map
}

variable "user_data" {
  description = "User data to launch the instance with.  Will be base64 encoded by this module."
  default     = ""
  type        = string
}

variable "volume_tags" {
  description = "Map of tags to add to attached EBS volumes"
  default     = {}
  type        = map
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the instance"
  type        = list(string)
}
