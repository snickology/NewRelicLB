# # Store the tfstate in S3
# terraform {
#   backend "s3" {
#     bucket = "var.bucket_name"
#     key    = "infrastructure/terraform.tfstate"
#     region = "us-west-1"
#   }
# }

provider "aws" {
  region = "us-west-1"
  #access_key = "<enter access key here>"
  #secret_key = "<my-secret-key>"
}

# Creat VPC and subnets
module "vpc" {
  source             = "./modules/vpc"
  vpc-cidr-block     = var.vpc-cidr-block
  subnet-cidr-block  = var.subnet-cidr-block
  subnet-cidr-block2 = var.subnet-cidr-block2
}

# Create Instances and Load Balancer
module "ec2" {
  source                 = "./modules/ec2"
  instance-count         = var.instance-count
  instance-type          = var.instance-type
  webserver-port         = var.webserver-port
  out-vpc-us-west-1      = module.vpc.out-vpc-us-west-1
  out-subnet-us-west-1-a = module.vpc.out-subnet-us-west-1-a
  out-subnet-us-west-1-b = module.vpc.out-subnet-us-west-1-b
}
