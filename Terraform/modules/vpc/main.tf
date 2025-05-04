#Creates the VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, { Name = var.name })
}

# Create a public subnet, which is accessbile from the internet 
# Each subnet maps to a specific Availability Zone (AZ), promoting high availability.
resource "aws_subnet" "public" {
  for_each = toset(var.public_subnets)
  vpc_id   = aws_vpc.main.id
  cidr_block = each.value
  availability_zone = element(var.azs, index(var.public_subnets, each.value))
  map_public_ip_on_launch = true
  tags = merge(var.tags, { Name = "public-${each.value}" })
}

# Create a private subnet 
resource "aws_subnet" "private" {
  for_each = toset(var.private_subnets)
  vpc_id   = aws_vpc.main.id
  cidr_block = each.value
  availability_zone = element(var.azs, index(var.private_subnets, each.value))
  tags = merge(var.tags, { Name = "private-${each.value}" })
}

# Public subnets can access the internet 
# The IGW is then connected to the public route table, allowing 0.0.0.0/0 outbound traffic.
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, { Name = "internet-gateway" })
}

# NAT gateway- Private subnets can access the internet securely
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.gw]
}

# Elastic IP for NAT gateway
resource "aws_eip" "nat" {
  vpc = true
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, { Name = "public-rt" })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(var.tags, { Name = "private-rt" })
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}
