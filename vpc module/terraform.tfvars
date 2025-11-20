vpc_name = "prod-vpc"
vpc_cidr = "10.25.0.0/16"

public_subnet_cidrs = [
  "10.25.1.0/24",
  "10.25.2.0/24",
  "10.25.3.0/24"
]

private_subnet_cidrs = [
  "10.25.11.0/24",
  "10.25.12.0/24",
  "10.25.13.0/24"
]

availability_zones = [
  "ap-south-1a",
  "ap-south-1b",
  "ap-south-1c"
]

igw_name                = "public-igw"
public_route_table_name = "public-rt"
private_route_table_name = "private-rt"
