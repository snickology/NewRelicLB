# vars passed from ../main.tf
variable "instance-count" {}
variable "instance-type" {}

# Get Linux AMI ID using SSM Paramater
data "aws_ssm_parameter" "linux-ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Create key-pair for logging into EC2 instance
resource "aws_key_pair" "webserver-key" {
  key_name   = "webserver-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create and bootstrap EC2 in us-west-1
resource "aws_instance" "webserver-instance" {
  count                       = var.instance-count
  ami                         = data.aws_ssm_parameter.linux-ami.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.webserver-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.webserver-sg.id]
  subnet_id = var.out-subnet-us-west-1-a
  tags = {
    Name = join("_", ["webserver", count.index + 1])
  }
  #depends_on = [aws_main_route_table_association.default-rt-assoc]
  user_data = file("user_data.sh")
}

output "out-webserver-instance" {
  value = aws_instance.webserver-instance
}
