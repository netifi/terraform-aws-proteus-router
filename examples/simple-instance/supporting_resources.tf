data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name           = "${var.name}"
  cidr           = "10.0.0.0/16"
  azs            = "${slice(data.aws_availability_zones.available.names, 0, 3)}"
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  tags = "${var.tags}"
}

resource "aws_security_group" "allow_router" {
  name        = "${var.name}"
  description = "Allow inbound traffic for router"
  vpc_id      = "${module.vpc.vpc_id}"
  tags        = "${merge(var.tags, map("Name", "${var.name}"))}"
}

resource "aws_security_group_rule" "allow_admin_port" {
  type        = "ingress"
  from_port   = 6001
  to_port     = 6001
  protocol    = "tcp"
  cidr_blocks = ["${var.security_group_cidr_blocks}"]

  security_group_id = "${aws_security_group.allow_router.id}"
}

resource "aws_security_group_rule" "allow_cluster_port" {
  type        = "ingress"
  from_port   = 7001
  to_port     = 7001
  protocol    = "tcp"
  cidr_blocks = ["${var.security_group_cidr_blocks}"]

  security_group_id = "${aws_security_group.allow_router.id}"
}

resource "aws_security_group_rule" "allow_router_port" {
  type        = "ingress"
  from_port   = 8001
  to_port     = 8001
  protocol    = "tcp"
  cidr_blocks = ["${var.security_group_cidr_blocks}"]

  security_group_id = "${aws_security_group.allow_router.id}"
}

resource "aws_security_group_rule" "allow_ssh_port" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["${var.security_group_cidr_blocks}"]

  security_group_id = "${aws_security_group.allow_router.id}"
}

resource "aws_security_group_rule" "allow_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.allow_router.id}"
}

resource "aws_key_pair" "default" {
  key_name   = "${var.name}"
  public_key = "${file("ssh_key/id_rsa.pub")}"
}
