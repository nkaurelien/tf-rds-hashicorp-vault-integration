
resource "aws_vpc" "main_vpc" {

  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr_block           = "10.0.0.0/16"

  tags = {
    Name = "Project Education VPC"
  }
}

resource "aws_subnet" "public_subnets" {
  count      = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
  # availability_zone = element(data.aws_availability_zones.available.names, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "Public Frontend Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count      = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = element(var.private_subnet_cidrs, count.index)
  # availability_zone = element(data.aws_availability_zones.available.names, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name = "Private Backend Subnet ${count.index + 1}"
  }
}

resource "aws_db_subnet_group" "education" {
  name = "education"
  # subnet_ids = [aws_subnet.public_subnets.id, aws_subnet.private_subnets.id]
  subnet_ids = concat([for s in aws_subnet.public_subnets : s.id], [for s in aws_subnet.private_subnets : s.id])

  tags = {
    Name = "Education"
  }
}

resource "aws_security_group" "rds" {
  name   = "education_rds"
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "education_rds"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_ingress" {
  security_group_id = aws_security_group.rds.id

  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "rds_egress" {
  security_group_id = aws_security_group.rds.id

  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main_vpc.id
 
 tags = {
   Name = "Project VPC IG"
 }
}

resource "aws_route_table" "second_rt" {
 vpc_id = aws_vpc.main_vpc.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }
 
 tags = {
   Name = "2nd Route Table"
 }
}

resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.second_rt.id
}