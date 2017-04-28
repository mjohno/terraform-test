# Variable Defaults
variable "aws_region" { default = "us-east-1"}
variable "instance_port" { default = 80 }
variable "route53_zone_id" { default = "Z3BRSPUKGCDDFR" }

# Setup AWS as a terraform provider
# Relies on having '.aws/credentials' available relative to the terraform call. 
provider "aws" {
  shared_credentials_file = ".aws/credentials"
  region                  = "${var.aws_region}"
}
