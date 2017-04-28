
# Variable Defaults
variable "aws_region" { default = "us-east-1"}
variable "instance_port" { default = 8080 }
variable "route53_zone_id" { default = "Z3BRSPUKGCDDFR" }

# Setup AWS as a terraform provider
# Relies on having '.aws/credentials' available relative to the terraform call. 
provider "aws" {
  shared_credentials_file = ".aws/credentials"
  region                  = "${var.aws_region}"
}

########### VPC ###########

resource "aws_vpc" "test" {
  cidr_block = "172.32.0.0/16"
}

resource "aws_subnet" "test_a" {
  vpc_id            = "${aws_vpc.test.id}"
  availability_zone = "${var.aws_region}a"
  cidr_block        = "172.32.0.0/24"
}

resource "aws_subnet" "test_b" {
  vpc_id            = "${aws_vpc.test.id}"
  availability_zone = "${var.aws_region}b"
  cidr_block        = "172.32.1.0/24"
}

resource "aws_route_table_association" "test_a" {
  subnet_id = "${aws_subnet.test_a.id}"
  route_table_id = "${aws_vpc.test.main_route_table_id}"
}

resource "aws_route_table_association" "test_b" {
  subnet_id = "${aws_subnet.test_b.id}"
  route_table_id = "${aws_vpc.test.main_route_table_id}"
}

resource "aws_internet_gateway" "test_gateway" {
  vpc_id = "${aws_vpc.test.id}"
}

resource "aws_route" "internet_gateway_route" {
  route_table_id = "${aws_vpc.test.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.test_gateway.id}"
}

########### ELB ###########

resource "aws_security_group" "elb" {
  name = "mj-elb-sg"
  description = "Security group used for ELBs used for Matts testing."
  vpc_id = "${aws_vpc.test.id}"
}

resource "aws_security_group_rule" "elb_ingress_http" {
  type = "ingress"
  from_port = 80
  to_port = 8080
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

########### Opsworks ###########

resource "aws_opsworks_stack" "test" {
  name                          = "mj-test-stack"
  region                        = "${var.aws_region}"
  service_role_arn              = "arn:aws:iam::623134608261:role/aws-opsworks-service-role"
  default_instance_profile_arn  = "arn:aws:iam::623134608261:instance-profile/aws-opsworks-ec2-role"
  vpc_id                        = "${aws_vpc.test.id}"
  default_subnet_id             = "${aws_subnet.test_a.id}"
  configuration_manager_version = "12"
  default_os                    = "Ubuntu 16.04 LTS"
}

resource "aws_opsworks_custom_layer" "test" {
  name       = "Matt's Test Layer"
  short_name = "mjt"
  stack_id   = "${aws_opsworks_stack.test.id}"
}
