variable "ingress_cidrs" {
  description = "List of CIDRs to be allowed TCP access to the file system."
  type        = list(string)
}

variable "kms_key_arn" {
  description = "KMS Key ARN for encryption.  Set to NO_ENCRYPTION to disable encryption."
  type        = string
}

variable "lifecycle_policy" {
  description = "Transition files to EFS IA storage class.  Disabled if empty (default).  Valid values: AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS, or AFTER_90_DAYS"
  default     = ""
  type        = string
}

variable "name" {
  description = "File System Name"
  type        = string
}

variable "performance_mode" {
  description = "File system performance mode.  generalPurpose or maxIO."
  default     = "generalPurpose"
  type        = string
}

variable "throughput_mode" {
  description = "Throughput Mode, defaults to busting.  Valid valids are busrting and provisioned.  Provisioned requires provisioned_throughput_in_mipbs set."
  default     = "bursting"
  type        = string
}

variable "provisioned_throughput_in_mibps" {
  description = "Network capacity in MiB/s.  Only valid with throughput_mode set to provisioned.  1-1024"
  default     = 1
  type        = number
}

variable "security_group_ids" {
  description = "List of additional security group IDs to associate with file system."
  default     = []
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs to deploy EFS endpoints in.  Private or Private Data subnets are highly recommended."
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all module resources."
  default     = {}
  type        = map
}
