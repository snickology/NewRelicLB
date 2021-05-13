# Source Linux AMI
data "aws_ami" "linux-ami" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20210427.0-x86_64-gp2"]
  }
}

# Create key-pair for logging into EC2 instance
resource "aws_key_pair" "webserver-key" {
  key_name   = "webserver-key"
  public_key = file(var.pub_key)
}

# Create and bootstrap EC2 in us-west-1
resource "aws_instance" "webserver-instance" {
  count                       = var.instance-count
  ami                         = data.aws_ami.linux-ami.id
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.webserver-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.webserver-sg.id]
  subnet_id                   = var.out-subnet-us-west-1-a
  tags = {
    Name = join("_", ["webserver", count.index + 1])
  }
  #depends_on = [aws_main_route_table_association.default-rt-assoc]
  user_data = file("user_data.sh")
}

output "out-webserver-instance" {
  value = aws_instance.webserver-instance
}
