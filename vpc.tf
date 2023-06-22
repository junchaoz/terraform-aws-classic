//Initiate VPC, 128 ips
resource "aws_vpc" "proj_vpc" {
  cidr_block           = "10.0.0.0/25"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = var.proj_tag
  }
}

//create a subnet in a avaiblable zone
resource "aws_subnet" "proj_public_a" {
  vpc_id                  = local.vpc_id
  cidr_block              = "10.0.0.0/26"
  availability_zone       = "${var.proj_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name   = var.proj_tag,
    Region = "Public Subnet in ${var.proj_region}a"
  }
}

//create subnet in b avaiblable zone
resource "aws_subnet" "proj_public_b" {
  vpc_id                  = local.vpc_id
  cidr_block              = "10.0.0.64/26"
  availability_zone       = "${var.proj_region}b"
  map_public_ip_on_launch = true
  tags = {
    Name   = var.proj_tag,
    Region = "Public Subnet in ${var.proj_region}b"
  }
}

//create internet IGW
resource "aws_internet_gateway" "proj_vpc_igw" {
  vpc_id = local.vpc_id
  tags = {
    Name = var.proj_tag
  }
}

//create public route table for public subnets
resource "aws_route_table" "proj_vpc_public_rt" {
  vpc_id = local.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.proj_vpc_igw.id
  }
  tags = {
    Name        = var.proj_tag,
    Description = "Public Subnets To Access Internet"
  }
}

//associte route table with subnet a
resource "aws_route_table_association" "proj_route_table_association_For_subnet_a" {
  subnet_id      = aws_subnet.proj_public_a.id
  route_table_id = aws_route_table.proj_vpc_public_rt.id
}

//associte route table with subnet b
resource "aws_route_table_association" "proj_route_table_association_For_subnet_b" {
  subnet_id      = aws_subnet.proj_public_b.id
  route_table_id = aws_route_table.proj_vpc_public_rt.id
}

//create local value for vpc name
locals {
  vpc_id     = aws_vpc.proj_vpc.id
  subnet_ids = [aws_subnet.proj_public_a.id, aws_subnet.proj_public_b.id]
}
