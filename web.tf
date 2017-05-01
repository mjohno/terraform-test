resource "aws_security_group" "web" {
  name = "mj-web-sg"
  description = "Security group used for webservers for Matts testing."
  vpc_id = "${aws_vpc.test.id}"
}

resource "aws_security_group_rule" "web_ingress_http" {
  type = "ingress"
  from_port = "${var.instance_port}"
  to_port = "${var.instance_port}"
  protocol = "tcp"
  security_group_id = "${aws_security_group.web.id}"
  cidr_blocks = ["${aws_security_group.elb.id}"]
}

resource "aws_security_group_rule" "web_egress_all" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.web.id}"
  cidr_blocks = ["0.0.0.0/0"]
}
