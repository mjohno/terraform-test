# Terraform Testing

## The Task!

Use Terraform to automate the provisioning of a stack within AWS that has 2 webservers, load balanced in 2 seperate availability zones.

## My Approach

* Learn a service I don't know in AWS manually (e.g. VPC's)
* Write Terraform
* terraform plan
* terraform apply
* Repeat

### Setup AWS Provider

* Use a relative path to an AWS credentials file, ignored from git repository

### Create the VPCs

* Create a VPC with IP range 172.32.0.0/24 (65536 IP's total). Thats a lot.
* Created 2 Subnets with IP range 172.32.0.0/16 and 172.32.1.0/16 for the different Availability Zones (512 IP's total).
* Way more IP's than required and I hardcoded the AZ's to be A and B. Other options are available.

### Create ELB

* Also required setting up Security Groups (Thanks Martin!). Created one for Incoming on port 80 from any IP and allowing all outbound traffic to pass.
* Set up a HTTP listener that Redirects traffic from the LB port 80 to the Instance Port (80 at the time of writing).
* No HTTPS! Investigated the use of AWS certificates Service -> Cannot assume a certificate would be available, no permissions to create one.

### Create Web Server Security Groups

* Similar to ELB. Enable traffic from ELB SG to Instance SG over port 80. Enable all outbound traffic.
* What this means, is that only traffic from the ELB can access our instance on a designated port.

### Setup Opsworks

* Create the Stack
  * Public IP
  * Hardcoded arn for `aws_iam_role` `aws_iam_instance_profile` which are required variables to build an opsworks stack since I did not have permissions to read it.
  * Defaut settings for a Stack is Chef 11 and Ubuntu 12.04. Had to customise.
  * Used demo deployment cookbook: https://s3.amazonaws.com/opsworks-demo-assets/opsworks-linux-demo-cookbooks-nodejs.tar.gz
* Create the Layer
  * Use Demo Application: https://github.com/awslabs/opsworks-windows-demo-nodejs.git 
* Build Instances using Opsworks Interface (1 in each AZ).

## Gotcha's

* Check for `<computed>` in terraform's output. If it isn't there you might've incorrectly interpolated a string variable.
* Sometimes newly created resources aren't yet available for dependencies. E.g. Internet Gateway required for an ELB. Had to run apply twice.
* Default resources are not managed by Terraform and it cannot manage them.

## TODO

* Do Chef Stuff... (Not a demo app)
* ELB Logging
* HTTPS traffic
* Use a smaller VPC?
