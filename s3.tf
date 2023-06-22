//create s3 bucket
resource "aws_s3_bucket" "proj_s3" {
  bucket = "${var.proj_name_prefix}-s3"

  tags = {
    Name = var.proj_tag
  }
}
