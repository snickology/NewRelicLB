# Create SG for LB that allows port 80 and outbound access
resource "aws_security_group" "lb-sg" {
  name        = "lb-sg"
  description = "Allow port 80 from anywhere"
  vpc_id      = var.out-vpc-us-west-1
  ingress {
    description = "Allow 80 from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create SG for allowing port 22 from anywhere.  I know, bad practice.
resource "aws_security_group" "webserver-sg" {
  name        = "webserver-sg"
  description = "Allow ssh port 22"
  vpc_id      = var.out-vpc-us-west-1
  ingress {
    description = "Allow ssh port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow traffic from VPC us-west-1"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.33.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
