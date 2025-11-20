variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
  description = "3 public subnets"
}

variable "private_subnet_cidrs" {
  type = list(string)
  description = "3 private subnets"
}

variable "availability_zones" {
  type = list(string)
  description = "AZs for each subnet"
}

variable "igw_name" {
  type = string
}

variable "public_route_table_name" {
  type = string
}

variable "private_route_table_name" {
  type = string
}
