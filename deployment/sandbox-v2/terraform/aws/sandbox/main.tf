provider "aws" {
  region = var.region
}

resource "aws_vpc" "sandbox" {
  cidr_block       = "10.20.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = var.sandbox_name
  }
}


resource "aws_subnet" "private" {
   count = length(var.private_subnets)
   vpc_id = aws_vpc.sandbox.id
   cidr_block = "10.20.${20+count.index}.0/24"
   tags = {
     Name = var.private_subnets[count.index]
   } 
   map_public_ip_on_launch = "true"
}

data "aws_subnet_ids" "private" {
  vpc_id = aws_vpc.sandbox.id
  depends_on = [aws_subnet.private]
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.sandbox.id
tags = {
    Name = "${var.sandbox_name}_gw"
  }
}

resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.sandbox.default_route_table_id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
    }

  tags = {
      Name = var.sandbox_name
  }
}





