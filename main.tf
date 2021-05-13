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

# # Create DNS Records
# module "dns" {
#   source                = "../modules/route53"
#   public_dns_zone       = var.public_dns_zone
#   private_dns_zone      = var.private_dns_zone
#   private_zone_comment  = var.private_zone_comment
#   priv_pub_dns_zone     = var.priv_pub_dns_zone
#   aws_vpc_id            = var.aws_vpc_id
#   limina_lb_name        = var.limina_lb_name
#   sql_lb                = var.sql_lb
#   portal_dns_record     = var.portal_dns_record
#   out_nginx_ext_alb     = module.lb.out_nginx_ext_alb
#   out_nginx_int_alb     = module.lb.out_nginx_int_alb
#   out_contentrepo_alb   = module.lb.out_contentrepo_alb
#   out_iis_alb           = module.lb.out_iis_alb
#   out_elasticsearch_alb = module.lb.out_elasticsearch_alb
# }
