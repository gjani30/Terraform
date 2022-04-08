resource "aws_launch_template" "template1" {
  name                   = "${var.AWS_ENV}-template1"
  image_id               = "ami-04505e74c0741db8d"
  instance_type          = var.INSTANCE_TYPE
  vpc_security_group_ids = [aws_security_group.main_sg.id]
  user_data              = filebase64("startup.sh")
  update_default_version = true
}


resource "aws_autoscaling_group" "asg" {
  name                = "${var.AWS_ENV}-ASG"
  vpc_zone_identifier = [aws_subnet.private_SN1.id, aws_subnet.private_SN2.id, aws_subnet.private_SN3.id]
  target_group_arns   = [aws_lb_target_group.alb_tg.id]
  desired_capacity    = 1
  max_size            = var.MAX_INSTANCES
  min_size            = 1

  launch_template {
    id      = aws_launch_template.template1.id
    version = "$Latest"
  }

  depends_on = [aws_route_table_association.rtbassoc4, aws_route_table_association.rtbassoc5, aws_route_table_association.rtbassoc6]
}