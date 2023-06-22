//create application load balancer
resource "aws_lb" "proj_alb" {
  name               = "${var.proj_name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.proj_alb_sg.id]
  subnets            = local.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = var.proj_tag
  }
}

output "alb_dns_name" {
  value = aws_lb.proj_alb.dns_name
}
