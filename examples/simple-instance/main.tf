module "router" {
  source = "../../"

  key_name               = "${aws_key_pair.default.key_name}"
  name                   = "${var.name}"
  subnet_id              = "${module.vpc.public_subnets[0]}"
  tags                   = "${var.tags}"
  vpc_security_group_ids = ["${aws_security_group.allow_router.id}"]
}
