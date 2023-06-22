//create auto scaling group
resource "aws_autoscaling_group" "proj_autoscaling_group" {
  name                      = "${var.proj_name_prefix}-autoscaling-group"
  max_size                  = var.proj_instance_size["max"]
  min_size                  = var.proj_instance_size["min"]
  desired_capacity          = var.proj_instance_size["desired"]
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = false
  vpc_zone_identifier       = local.subnet_ids
  target_group_arns         = [aws_lb_target_group.proj_asg_target_group.arn]

  launch_template {
    id      = aws_launch_template.proj_launch_template.id
    version = "$Latest"
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Name"
    value               = var.proj_tag
    propagate_at_launch = true
  }

}
