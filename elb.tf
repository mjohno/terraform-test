resource "aws_security_group" "elb" {
  name = "mj-elb-sg"
  description = "Security group used for ELBs used for Matts testing."
  vpc_id = "${aws_vpc.test.id}"
}

resource "aws_security_group_rule" "elb_ingress_http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  security_group_id = "${aws_security_group.elb.id}"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "elb_egress_all" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.elb.id}"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_elb" "test" {
  name               = "mj-test"
  subnets            = ["${aws_subnet.test_a.id}", "${aws_subnet.test_b.id}"]
  security_groups    = ["${aws_security_group.elb.id}"]

  listener {
    instance_port     = "${var.instance_port}"
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:${var.instance_port}/"
    interval            = 30
  }
}
