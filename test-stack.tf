
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
