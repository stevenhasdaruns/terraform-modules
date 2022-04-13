variable "ami" {
  description = "Amazon Linux AMI in the target region."
  type        = string
}

variable "disable_api_termination" {
  description = "Termination protection."
  default     = true
  type        = bool
}

variable "ebs_encryption" {
  description = "Encrypt root EBS volume"
  default     = false
  type        = bool
}

variable "ebs_kms_key_id" {
  description = "KMS Key ID.  Required if encryption is enabled."
  default     = ""
  type        = string
}


variable "enable_ssm" {
  description = "Enable Systems Manager (SSM) access. *Required to set initial password.*"
  default     = true
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance type."
  default     = "t3.small"
  type        = string
}

variable "key_name" {
  description = "Key pair name."
  type        = string
}

variable "name" {
  description = "Name used for instance, IAM role, and security group."
  type        = string
}

variable "root_volume_size" {
  description = "Size in GB of root EBS volume."
  default     = 16
  type        = number
}

variable "subnet_id" {
  description = "Target public subnet ID for deployment."
  type        = string
}

variable "tags" {
  description = "Tags to apply to all stack resources."
  default     = {}
  type        = map
}

variable "vpc_cidr" {
  description = "VPC CIDR of the target VPC."
  type        = string
}

variable "vpn_ingress_cidr" {
  description = "This CIDR range will be allowed to connect to ports 443 (HTTPS) and 1194 (UDP OpenVPN)."
  default     = "0.0.0.0/0"
  type        = string
}
