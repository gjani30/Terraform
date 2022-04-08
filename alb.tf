resource "aws_lb" "main_alb" {
  name               = "${var.AWS_ENV}-ALB"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_SN1.id, aws_subnet.public_SN2.id, aws_subnet.public_SN3.id]
  security_groups    = [aws_security_group.main_sg.id]
}


resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.AWS_ENV}-ALB-TG"
  protocol = "HTTP"
  port     = 80
  vpc_id   = aws_vpc.main.id
  health_check {
    interval            = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 4
  }
}


resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}