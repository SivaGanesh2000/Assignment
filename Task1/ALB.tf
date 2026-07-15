## Create a Public Loab Balance for front end access
# Allowing port 80 from everywhere 

resource "aws_lb" "alb" {
  name               = var.alb_name
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for subnet in aws_subnet.pblc : subnet.id]
}

# Create a Loab balancer Target Group 
# Health check rules to check if underlying instance are responding on port 80
resource "aws_lb_target_group" "name" {
  name     = "${aws_lb.alb.name}-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

# Attach the Target Group to the created EC2 instance
resource "aws_lb_target_group_attachment" "name" {
  target_group_arn = aws_lb_target_group.name.arn
  target_id        = aws_instance.ec2.id
  port             = 80
  lifecycle {
    replace_triggered_by = [aws_instance.ec2]
  }
}

# listener rules to forward to underlying Traget Groups
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.name.arn
  }
}