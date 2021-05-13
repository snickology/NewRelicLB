# New Relic - Load Balancer Challenge

# Intro
Thank you for the opportunity to interview with New Relic.  I hope this Terraform code satisfies your challenge requirements.  If you have any questions please feel free to ask.

# Overview
This is a Terraform that will deploy and configure AWS infrastructure.  The goal is to deploy a load balancer service with 2 back end servers.  This Terraform assumes you have no infrastructure in place yet--just an AWS account and user credentials.

# Details
This Terraform will deploy:
- VPC and subnets (us-west-1)
- EC2 instances (2) running Linux and Apache webserver (httpd)
- Security Groups
- Applicaton Load Balancer with a health check

# Requirements
1. AWS tenant and user account with admin rights
2. An access key and secret to configure AWS infrastructure
3. Terraform installed on your local system.  I used Terraform v0.14.9
4. A key pair to use for adding to ec2 instances for login access (although you should not have to login to any instances)

# Important!!!
Make sure you do not have a VPC using the same CIDR blocks used in this lab.  Any changes you would have to make, such as CIDR blocks for subnets, are in the variables.tf file.  Also make sure to destroy the Terraform when completed.

# Instructions
1. Set your AWS credentials.  If you have AWS CLI installed and configured then you are good to go.  If you prefer to manually enter your credentials, you can uncomment the credentials in the provider block (main.tf) and enter your credentials there.
2. Update the path to your public key in terraform config.
3. Run 'terraform init'
  - I intentionally chose not to store the Terraform state file in S3.  This would be ideal but not necessary for this challenge.  Instead it will be stored locally.
4. Run 'terraform plan'
  - There should be no errors and should be good to go.  If you do run in to errors here then I have missed something.  Please contact me.
5. Run 'terraform apply' and type yes when prompted or 'terraform apply -auto-approve' to bypass confirmation.
6. Make note (copy) of the load balancer public DNS record
7. Enter the DNS record in to your browser and you should hit one of the backend servers.  Keep refreshing and you will alternate servers based on default load balancer config (round-robin).
8. When you are ready to destroy the environment, run 'terraform destroy'.
