################################################################################
# AWS_INTERNET_GATEWAY Resource
################################################################################
# Only One Internet Gateway per VPC
resource "aws_internet_gateway" "this" {
  vpc_id = var.values.VPC_ID
  tags = {
    Name = "vpc-internet-gateway"
  }
}

################################################################################
# AWS_NAT_GATEWAY Resource
################################################################################
# Regional NAT Gateway (multi-AZ) with auto mode is a new Gateway Resource that offers high availability across AZs
# Only One Regional NAT Gateway per VPC
resource "aws_nat_gateway" "this" {
  vpc_id            = var.values.VPC_ID
  connectivity_type = "public"
  availability_mode = "regional"

  tags = {
    Name = "regional-nat-gateway"
  }
  #It's recommended to denote the NAT Gateway depends on the Internet Gateway for the VPC.
  depends_on  = [aws_internet_gateway.this]
}

################################################################################
# AWS_ROUTE_TABLE Resource
################################################################################

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = var.values.VPC_ID
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "vpc-public-route-table"
  }
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = var.values.VPC_ID
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
  tags = {
    Name = "vpc-private-route-table"
  }
}
