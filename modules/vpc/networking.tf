# Create VPC in us-west-1
resource "aws_vpc" "vpc-us-west-1" {
  cidr_block           = var.vpc-cidr-block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "NewRelicVPC"
  }
}

output "out-vpc-us-west-1" {
  value = aws_vpc.vpc-us-west-1.id
}

# Create IGW in us-west-1
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-us-west-1.id
}

# Get all available AZ's in VPC
data "aws_availability_zones" "azs" {
  state = "available"
}

# Create subnet in us-west-1
resource "aws_subnet" "subnet-us-west-1-a" {
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc-us-west-1.id
  cidr_block        = var.subnet-cidr-block
}

# Create subnet2 in us-west-1
resource "aws_subnet" "subnet-us-west-1-b" {
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc-us-west-1.id
  cidr_block        = var.subnet-cidr-block2
}

output "out-subnet-us-west-1-a" {
  value = aws_subnet.subnet-us-west-1-a.id
}

output "out-subnet-us-west-1-b" {
  value = aws_subnet.subnet-us-west-1-b.id
}

# Create route table in us-west-1
resource "aws_route_table" "internet_route" {
  vpc_id = aws_vpc.vpc-us-west-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "NewRelicRouteTable"
  }
}

# Overwrite default route table of vpc-us-west-1 with new route table entries created above
resource "aws_main_route_table_association" "default-rt-assoc" {
  vpc_id         = aws_vpc.vpc-us-west-1.id
  route_table_id = aws_route_table.internet_route.id
}
