
//iam role for ec2 created by auto scaling group
resource "aws_iam_role" "proj_ec2_for_s3_role" {
  name = "${var.proj_name_prefix}-ec2-for-s3-role"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF

  tags = {
    Name = var.proj_tag
  }
}

//attach role policy to role
resource "aws_iam_role_policy" "proj_ec2_for_s3_role_policy" {
  name = "${var.proj_name_prefix}-ec2-for-s3-role-policy"
  role = aws_iam_role.proj_ec2_for_s3_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "${var.proj_ec2_allowed_actions_for_s3}"
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.proj_s3.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.proj_s3.bucket}/*"
        ]
      },
    ]
  })


}

//create iam instance profile for the s3 role
resource "aws_iam_instance_profile" "proj_ec2_for_s3_profile" {
  name = "${var.proj_name_prefix}-ec2-for-s3-profile"
  role = aws_iam_role.proj_ec2_for_s3_role.name

  tags = {
    Name = var.proj_tag
  }
}
