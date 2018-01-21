# Proteus Router Instance Terraform Module

This module is intended to be used for development and demos to quickly spin up a Proteus Router.

In the [simple-instance](/examples/simple-instance/README.md) example we spin up a vpc and key_pair so that you can quickly get started developing against the router.


# Usage

You can use this module is an existing project like so:

```hcl
local {
    extra_tags = {
        Env = "dev"
    }
}

module "router" {
  source = "netifi/proteus-router/aws"

  key_name               = "${var.key_name}"
  name                   = "${var.name}"
  subnet_id              = "${var.subnet_id}"
  tags                   = "${local.extra_tags}"
  vpc_security_group_ids = ["${var.security_groups}"]
}
```
