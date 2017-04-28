resource "aws_opsworks_stack" "test" {
  name                          = "mj-test-stack"
  region                        = "${var.aws_region}"
  service_role_arn              = "arn:aws:iam::623134608261:role/aws-opsworks-service-role"
  default_instance_profile_arn  = "arn:aws:iam::623134608261:instance-profile/aws-opsworks-ec2-role"
  vpc_id                        = "${aws_vpc.test.id}"
  default_subnet_id             = "${aws_subnet.test_a.id}"
  configuration_manager_version = "12"
  default_os                    = "Ubuntu 16.04 LTS"
  use_custom_cookbooks          = true
  default_root_device_type      = "ebs"
  custom_cookbooks_source       = {
    type = "archive"
    url  = "https://s3.amazonaws.com/opsworks-demo-assets/opsworks-linux-demo-cookbooks-nodejs.tar.gz"
  }
}

resource "aws_opsworks_custom_layer" "test" {
  name                      = "Matt's Test Layer"
  short_name                = "mjt"
  stack_id                  = "${aws_opsworks_stack.test.id}"
  elastic_load_balancer     = "${aws_elb.test.name}"
  custom_security_group_ids = ["${aws_security_group.web.id}"]
  custom_deploy_recipes     = ["nodejs_demo"]
  auto_assign_public_ips    = true
}

resource "aws_opsworks_application" "test" {
  name        = "Matt Test"
  short_name  = "mjt"
  stack_id    = "${aws_opsworks_stack.test.id}"
  type        = "other"
  description = "The Sample NodeJS Application"

  environment = {
    key    = "APP_ADMIN_EMAIL"
    value  = "mattgjo@gmail.com"
    secure = false
  }

  app_source = {
    type     = "git"
    revision = "master"
    url      = "https://github.com/awslabs/opsworks-windows-demo-nodejs.git"
  }
}
