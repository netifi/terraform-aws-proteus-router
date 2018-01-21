terraform {
  required_version = "~> 0.11"
}

provider "aws" {
  version = "~> 1.0.0"
  region  = "${var.aws_region}"
}

provider "template" {
  version = "~> 1.0"
}

variable "aws_region" {
  type    = "string"
  default = "us-east-1"
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "security_group_cidr_blocks" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "name" {
  type    = "string"
  default = "simple-instance-proteus-router-test"
}
