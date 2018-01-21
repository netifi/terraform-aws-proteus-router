variable "name" {
  type        = "string"
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "tags" {
  type        = "map"
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "subnet_id" {
  type        = "string"
  description = "A subnet id the router should be launched into"
  default     = ""
}

variable "vpc_security_group_ids" {
  type        = "list"
  description = "A list of security groups the instance should be launched into"
  default     = []
}

variable "key_name" {
  type        = "string"
  description = "The key pair name to launch the instance with"
  default     = ""
}

variable "instance_type" {
  type        = "string"
  description = "The instance_type of the instance"
  default     = "t2.small"
}

variable "ebs_optimized" {
  type        = "string"
  description = "Should the instance be ebs_optimized"
  default     = "false"
}

variable "router_access_key" {
  type        = "string"
  description = "Proteus Router access key"
  default     = "7685465987873703191"
}

variable "router_access_token" {
  type        = "string"
  description = "Proteus Router access token"
  default     = "PYYgV9XHSJ/3KqgK5wYjz+73MeA="
}

variable "router_account_id" {
  type        = "string"
  description = "Proteus Router account id"
  default     = "100"
}
