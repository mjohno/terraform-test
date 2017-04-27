
# Variable Defaults
variable "aws_region" { default = "us-east-1"}
variable "instance_port" { default = 8080 }
variable "route53_zone_id" { default = "Z3BRSPUKGCDDFR" }

# Setup AWS as a terraform provider
# Relies on having '.aws/credentials' available relative to the terraform call. 
provider "aws" {
  shared_credentials_file = ".aws/credentials"
  region = "${var.aws_region}"
}

resource "aws_vpc" "mj-trial" {
  cidr_block = "172.32.0.0/16"
}

resource "aws_subnet" "mj-trial-a" {
  vpc_id     = "${aws_vpc.mj-trial.id}"
  availability_zone = "${var.aws_region}a"
  cidr_block = "172.32.0.0/24"
}

resource "aws_subnet" "mj-trial-b" {
  vpc_id     = "${aws_vpc.mj-trial.id}"
  availability_zone = "${var.aws_region}b"
  cidr_block = "172.32.1.0/24"
}
