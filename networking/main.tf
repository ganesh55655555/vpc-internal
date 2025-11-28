variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "eu_availability_zone" {}
variable "cidr_private_subnet" {}

# ---------------------------
# Setup VPC
# ---------------------------
resource "aws_vpc" "testing-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

# ---------------------------
# Setup Public Subnets
# ---------------------------
resource "aws_subnet" "testing_1_public_subnets" {
  count             = length(var.cidr_public_subnet)
  vpc_id            = aws_vpc.testing-vpc.id
  cidr_block        = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  map_public_ip_on_launch = true

  tags = {
    Name = "testing-public-subnet-${count.index + 1}"
  }
}

# ---------------------------
# Setup Private Subnets
# ---------------------------
resource "aws_subnet" "testing_1_private_subnets" {
  count             = length(var.cidr_private_subnet)
  vpc_id            = aws_vpc.testing-vpc.id
  cidr_block        = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name = "testing-private-subnet-${count.index + 1}"
  }
}

# ---------------------------
# Setup Internet Gateway
# ---------------------------
resource "aws_internet_gateway" "public_internet_gateway" {
  vpc_id = aws_vpc.testing-vpc.id
  tags = {
    Name = "testing-internetgateway"
  }
}

# ---------------------------
# Public Route Table
# ---------------------------
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.testing-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_internet_gateway.id
  }
  tags = {
    Name = "public-route"
  }
}

# ---------------------------
# Private Route Table
# ---------------------------
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.testing-vpc.id
  tags = {
    Name = "private-rt"
  }
}

# ---------------------------
# Public Route Table Association
# ---------------------------
resource "aws_route_table_association" "public_rt_subnet_association" {
  count          = length(aws_subnet.testing_1_public_subnets)
  subnet_id      = aws_subnet.testing_1_public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# ---------------------------
# Private Route Table Association
# ---------------------------
resource "aws_route_table_association" "private_rt_subnet_association" {
  count          = length(aws_subnet.testing_1_private_subnets)
  subnet_id      = aws_subnet.testing_1_private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

# ---------------------------
# Elastic IP for NAT Gateway
# ---------------------------
resource "aws_eip" "nat_eip" {
  #vpc = true
  tags = {
    Name = "nat-eip"
  }
}

# ---------------------------
# NAT Gateway in Public Subnet
# ---------------------------
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.testing_1_public_subnets[0].id  # NAT in first public subnet
  tags = {
    Name = "nat-gateway"
  }

  depends_on = [aws_internet_gateway.public_internet_gateway]
}

# ---------------------------
# Default Route for Private Subnets via NAT
# ---------------------------
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

# ---------------------------
# Outputs
# ---------------------------
output "vpc_id" {
  value = aws_vpc.testing-vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.testing_1_public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.testing_1_private_subnets[*].id
}

output "public_subnet_cidrs" {
  value = aws_subnet.testing_1_public_subnets[*].cidr_block
}

output "private_subnet_cidrs" {
  value = aws_subnet.testing_1_private_subnets[*].cidr_block
}
