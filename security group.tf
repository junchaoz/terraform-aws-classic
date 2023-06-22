//Create security group for ec2 instance
resource "aws_security_group" "proj_ec2_sg" {
  name   = "${var.proj_name_prefix}-ec2-security-group"
  vpc_id = local.vpc_id

  dynamic "ingress" {
    for_each = var.ports_for_ec2_sg
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.proj_tag
  }
}

//Create security group for ALB
resource "aws_security_group" "proj_alb_sg" {
  name   = "${var.proj_name_prefix}-alb-security-group"
  vpc_id = local.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.proj_tag
  }
}

// rds security group
resource "aws_security_group" "proj_rds_sg" {
  name   = "${var.proj_name_prefix}-rds-security-group"
  vpc_id = local.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.proj_ec2_sg.id]
  }

  tags = {
    Name = var.proj_tag
  }
}
