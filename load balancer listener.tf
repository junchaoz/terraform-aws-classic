//create lb listener
resource "aws_lb_listener" "proj_lb_listener" {
  load_balancer_arn = aws_lb.proj_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.proj_asg_target_group.arn //asg with ec2 instances target group
  }

  tags = {
    Name = var.proj_tag
  }
}
