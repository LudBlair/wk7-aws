## vpc code

resource "aws_vpc" "vpc" {
  cidr_block = "172.120.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags={
    Name = "utc-app"
    env = "Dev"
    team = "DevOps"
  }
}

## internet gateway

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
    tags={
    Name = "utc-app"
    env = "Dev"
    team = "DevOps"
  }
}

#public-subnet

resource "aws_subnet" "pub-sub" {
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block = "172.120.1.0/24"
  availability_zone = "us-east-1a"
      tags={
    Name = "public-us-east-1a"
  }
}
resource "aws_subnet" "pub-sub2" {
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block = "172.120.2.0/24"
  availability_zone = "us-east-1b"
        tags={
    Name = "public-us-east-1b"
  }
}

#private-subnet

resource "aws_subnet" "private-sub" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "172.120.3.0/24"
  availability_zone = "us-east-1a"
        tags={
    Name = "private-us-east-1a"
}
}
resource "aws_subnet" "private-sub2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "172.120.4.0/24"
  availability_zone = "us-east-1b"
        tags={
    Name = "private-us-east-1b"
}
}

#elastic ip & nat gateway

resource "aws_eip" "eip" {
}
resource "aws_nat_gateway" "ng" {
  subnet_id = aws_subnet.pub-sub.id
  allocation_id = aws_eip.eip.id
  tags={
    name = "nat-gateway"
    env = "dev"
  }
}

#private route table 

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ng.id
  }
}

#public route table

resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}

#private route table association

resource "aws_route_table_association" "rta" {
  subnet_id = aws_subnet.private-sub.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.private-sub2.id
  route_table_id = aws_route_table.rt.id
}

#public route table association

resource "aws_route_table_association" "pubrta" {
  subnet_id = aws_subnet.pub-sub.id
  route_table_id = aws_route_table.rt2.id
}
resource "aws_route_table_association" "pubrta2" {
  subnet_id = aws_subnet.pub-sub2.id
  route_table_id = aws_route_table.rt2.id
}