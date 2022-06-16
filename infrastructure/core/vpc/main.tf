# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# AWS NETWORKING
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_vpc" "keepcoding" {
  cidr_block       = "172.31.0.0/16"
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "keepcoding-masters"
    Environment = var.environment
    Creator     = var.creator
    Team        = var.team
    Entity      = var.entity
  }
}

resource "aws_subnet" "public_subnet_10" {
  vpc_id                  = aws_vpc.keepcoding.id
  cidr_block              = "172.31.10.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  tags                    = {
    Name        = "PublicSubnet10"
    Environment = var.environment
    Creator     = var.creator
    Team        = var.team
    Entity      = var.entity
  }
  depends_on = [aws_vpc.keepcoding]
}
resource "aws_subnet" "public_subnet_11" {
  vpc_id                  = aws_vpc.keepcoding.id
  cidr_block              = "172.31.11.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true
  tags                    = {
    Name        = "PublicSubnet11"
    Environment = var.environment
    Creator     = var.creator
    Team        = var.team
    Entity      = var.entity
  }
  depends_on = [aws_vpc.keepcoding]
}
resource "aws_subnet" "public_subnet_12" {
  vpc_id                  = aws_vpc.keepcoding.id
  cidr_block              = "172.31.12.0/24"
  availability_zone       = "eu-central-1c"
  map_public_ip_on_launch = true
  tags                    = {
    Name        = "PublicSubnet12"
    Environment = var.environment
    Creator     = var.creator
    Team        = var.team
    Entity      = var.entity
  }
  depends_on = [aws_vpc.keepcoding]
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.keepcoding.id

  tags = {
    Name        = "keepcoding-gateway"
    Environment = var.environment
    Creator     = var.creator
    Team        = var.team
    Entity      = var.entity
  }
  depends_on = [aws_vpc.keepcoding]
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.keepcoding.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name        = "keepcoding-routing-table"
    Environment = var.environment
    Creator     = var.creator
    Team        = var.team
    Entity      = var.entity
  }
  depends_on = [aws_vpc.keepcoding]
}

resource "aws_route_table_association" "public-rt-subnets_10" {
  subnet_id      = aws_subnet.public_subnet_10.id
  route_table_id = aws_route_table.rt.id
  depends_on     = [aws_subnet.public_subnet_10, aws_route_table.rt]
}

resource "aws_route_table_association" "public-rt-subnets_11" {
  subnet_id      = aws_subnet.public_subnet_11.id
  route_table_id = aws_route_table.rt.id
  depends_on     = [aws_subnet.public_subnet_11, aws_route_table.rt]
}

resource "aws_route_table_association" "public-rt-subnets_12" {
  subnet_id      = aws_subnet.public_subnet_12.id
  route_table_id = aws_route_table.rt.id
  depends_on     = [aws_subnet.public_subnet_12, aws_route_table.rt]
}