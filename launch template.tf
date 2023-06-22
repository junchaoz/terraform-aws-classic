//date block to retrieve the AMI ID
data "aws_ami" "proj_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "description"
    values = ["Amazon Linux 2 Kernel*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

// Define the Launch Template
resource "aws_launch_template" "proj_launch_template" {
  name          = "${var.proj_name_prefix}-launch-template"
  image_id      = data.aws_ami.proj_ami.id
  instance_type = var.proj_instance_type

  // Define the Security Group for the instances
  vpc_security_group_ids = [aws_security_group.proj_ec2_sg.id]

  //assign iam role for launched ec2 instances
  iam_instance_profile {
    name = aws_iam_instance_profile.proj_ec2_for_s3_profile.name
  }

  user_data = base64encode(var.user_data_script)

  tags = {
    Name = var.proj_tag
  }

}
