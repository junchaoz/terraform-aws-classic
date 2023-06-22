//create load balancer target group
resource "aws_lb_target_group" "proj_asg_target_group" {
  name     = "${var.proj_name_prefix}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  tags = {
    Name = var.proj_tag
  }
}
