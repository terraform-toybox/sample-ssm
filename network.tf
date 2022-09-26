##############
# Data Block #
##############
data "aws_availability_zones" "available" {
  state = "available"
}

#######
# VPC #
#######
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/21"

  enable_dns_support   = true      # Indicates whether the DNS resolution is supported
  enable_dns_hostnames = false     # Indicates whether instances with public IP addresses get corresponding public DNS hostnames.
  instance_tenancy     = "default" # The VPC runs on shared hardware by default,

  tags = {
    "Name" = "vpc-ssm-test-ue1"
  }
}
 
####################
# Internet Gateway #
####################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    "Name" = "igw-ssm-test-ue1"
  }
}

##################
# Public Subnets #
##################
resource "aws_subnet" "pub" {
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = false

  cidr_block        = "10.0.0.0/23"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    "Name" = "snet-ssm-test-pub"
  }
}

###################
# Private Subnets #
###################
resource "aws_subnet" "pri" {
  vpc_id = aws_vpc.this.id

  cidr_block        = "10.0.4.0/23"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    "Name" = "snet-ssm-test-pri"
  }
}

##############
# Elastic IP #
##############
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    "Name" = "eip-ssm-test-ue1-nat"
  }
}

#######################################
# Network Address Translation Gateway #
#######################################
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pub.id

  tags = {
    "Name" = "nat-ssm-test-ue1"
  }
}
