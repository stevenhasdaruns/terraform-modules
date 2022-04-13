# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
variable "aws_alb_log_account" {
  description = "AWS Account ID to allow permission to put logs into S3"

  default = {
    us-east-1      = "127311923021" # US East (N. Virginia)
    us-east-2      = "033677994240" # US East (Ohio)
    us-west-1      = "027434742980" # US West (N. California)
    us-west-2      = "797873946194" # US West (Oregon)
    ca-central-1   = "985666609251" # Canada (Central)
    eu-central-1   = "054676820928" # Europe (Frankfurt)
    eu-west-1      = "156460612806" # Europe (Ireland)
    eu-west-2      = "652711504416" # Europe (London)
    eu-west-3      = "009996457667" # Europe (Paris)
    eu-north-1     = "897822967062" # Europe (Stockholm)
    ap-east-1      = "754344448648" # Asia Pacific (Hong Kong)
    ap-northeast-1 = "582318560864" # Asia Pacific (Tokyo)
    ap-northeast-2 = "600734575887" # Asia Pacific (Seoul)
    ap-northeast-3 = "383597477331" # Asia Pacific (Osaka-Local)
    ap-southeast-1 = "114774131450" # Asia Pacific (Singapore)
    ap-southeast-2 = "783225319266" # Asia Pacific (Sydney)
    ap-south-1     = "718504428378" # Asia Pacific (Mumbai)
    me-south-1     = "076674570225" # Middle East (Bahrain)
    sa-east-1      = "507241528517" # South America (São Paulo)
  }

  type = map(any)
}

variable "s3_block_all_public_access" {
  description = "Block S3 public access to the logging bucket"
  default     = true
  type        = bool
}

variable "enable_access_logs" {
  description = "Enable access logging to S3"
  default     = true
  type        = bool
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection."
  default     = true
  type        = bool
}

variable "existing_log_bucket_name" {
  description = "Name of an existing ALB log bucket name.  Must be empty if log_bucket_name is set."
  default     = ""
  type        = string
}

variable "idle_timeout" {
  description = "Connection idle timeout."
  default     = 60
  type        = string
}

variable "internal" {
  description = "Internal or external.  Internal cannot be reached from the internet."
  default     = false
  type        = bool
}

variable "log_bucket_name" {
  description = "ALB log bucket name.  Empty value set to alb-logs-ACCOUNTID-albname in module.  Unused if existing_log_bucket_name is set."
  default     = ""
  type        = string
}

variable "log_expiration" {
  description = "Enable ALB logs in S3 to expire"
  default     = true
  type        = string
}

variable "log_expiration_days" {
  description = "Days before expiring ALB log in S3"
  default     = 30
  type        = number
}

variable "name" {
  description = "ALB name.  Also used for security group prefix."
  type        = string
}

variable "security_group_ids" {
  description = "List of additional security groups to associate with cluster instances."
  default     = []
  type        = list(any)
}

variable "subnet_ids" {
  description = "List of subnets ALB will be deployed in."
  type        = list(any)
}

variable "tags" {
  description = "Tags to apply to all module resources."
  default     = {}
  type        = map(any)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
