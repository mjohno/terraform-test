# Terraform Testing

## NodeJS Demo

https://s3.amazonaws.com/opsworks-demo-assets/opsworks-linux-demo-cookbooks-nodejs.tar.gz

## VPC Info

* Any IP range -> Chose 172.32.0.0/24. Seems to be default, lots of room to scale.
* Created 2 subnets -> 172.32.1.0/16 and 172.32.0.0/16. Uses seperate AZ's by default.


## Gotcha's

* Hardcoded arn for `aws_iam_role` `aws_iam_instance_profile` which are required variables to build an opsworks stack since I did not have permissions to read it.
* Default settings for an opswork stack is Chef 11 and Ubuntu 12.04. Needed to change this.
