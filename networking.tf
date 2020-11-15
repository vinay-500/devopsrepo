# Create VPCs
resource "aws_vpc" "vpc_appup" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Appup East 2 VPC"
  }

  # DB Needs DNS resolutions  
  enable_dns_hostnames = true
  enable_dns_support   = true
}

data "aws_availability_zones" "azs" {
}

variable "subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# Create Subnets in various avaialability zones 
resource "aws_subnet" "subnet_appup" {
  count             = 3
  vpc_id            = aws_vpc.vpc_appup.id
  cidr_block        = element(var.subnets, count.index)
  availability_zone = element(data.aws_availability_zones.azs.names, count.index)
  tags = {
    Name = "Subnets - ${count.index}"
  }
}

# Internet Gateway
# Create IG, Assign to VPC. Create Route - add IG. Assign route table to all subnets
resource "aws_internet_gateway" "appup_igw" {
  vpc_id = aws_vpc.vpc_appup.id
}
# Route table: attach Internet Gateway 
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_appup.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.appup_igw.id
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "a" {
  count          = length(aws_subnet.subnet_appup)
  subnet_id      = element(aws_subnet.subnet_appup.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

output "VPC" {
  value       = aws_vpc.vpc_appup.id
  description = "VPC Name"
}

output "Subnets" {
  value       = aws_subnet.subnet_appup.*.id
  description = "Subnets Name"
}
