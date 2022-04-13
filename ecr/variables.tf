variable "name" {
  description = "Repository name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all module resources."
  default     = {}
  type        = map
}


variable "untagged_retention" {
  description = "Number of days to retain untagged images"
  default     = 30
  type        = number
}
