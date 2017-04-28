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
  name                  = "Matt's Test Layer"
  short_name            = "mjt"
  stack_id              = "${aws_opsworks_stack.test.id}"
  elastic_load_balancer = "${aws_elb.test.name}"
}
