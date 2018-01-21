data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "router" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  ebs_optimized          = "${var.ebs_optimized}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  subnet_id              = "${var.subnet_id}"
  user_data              = "${data.template_file.init.rendered}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

# Template for initial configuration bash script
data "template_file" "init" {
  template = "${file("${path.module}/init.tpl")}"

  vars {
    access_key   = "${var.router_access_key}"
    access_token = "${var.router_access_token}"
    account_id   = "${var.router_account_id}"
  }
}
