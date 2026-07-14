resource "aws_lb" "alb" {
  name               = var.alb_name
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for subnet in aws_subnet.pblc : subnet.id]
}

resource "aws_lb_target_group" "name" {
  name     = "${aws_lb.alb.name}-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}


resource "aws_lb_target_group_attachment" "name" {
  target_group_arn = aws_lb_target_group.name.arn
  target_id        = aws_instance.ec2.id
  port             = 80
  lifecycle {
    replace_triggered_by = [aws_instance.ec2]
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.name.arn
  }
}