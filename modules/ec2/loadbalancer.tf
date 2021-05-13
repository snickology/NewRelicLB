# Create ALB
resource "aws_lb" "webserver-lb" {
  name               = "webserver-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [var.out-subnet-us-west-1-a, var.out-subnet-us-west-1-b]
  tags = {
    Name = "NewRelic-LB"
  }
}

output "out-webserver-lb" {
  value = aws_lb.webserver-lb
}

# Create target group
resource "aws_alb_target_group" "app-lb-tg" {
  name        = "app-lb-tg"
  port        = var.webserver-port
  target_type = "instance"
  vpc_id      = var.out-vpc-us-west-1
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = var.webserver-port
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "NewRelic-Target-Group"
  }
}

# Create listener
resource "aws_lb_listener" "listener-http" {
  load_balancer_arn = aws_lb.webserver-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app-lb-tg.arn
  }
}

# Attach instances to target group
resource "aws_alb_target_group_attachment" "tg-attach" {
  target_group_arn = aws_alb_target_group.app-lb-tg.arn
  port             = var.webserver-port
  count            = var.instance-count
  target_id        = element(split(",", join(",", aws_instance.webserver-instance.*.id)), count.index)
}
