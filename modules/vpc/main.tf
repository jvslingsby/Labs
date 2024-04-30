#-----vpc/main.tf-----
#======================
provider "aws" {
  region = var.region
}

#Get all available AZ's in VPC for this region
#================================================
data "aws_availability_zones" "azs" {
  state = "available"
}

#Create VPC in us-east-1
#========================
resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Terraform-VPC"
  }
}


#Create IGW in us-east-1
#========================
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "Terraform-Gateway"
  }
}

#Create public route table in us-east-1
#=======================================
resource "aws_route_table" "tf_public_route" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
  tags = {
    Name = "Terraform-Public-RouteTable"
  }
}

#Create subnet # 1 in us-east-1 
#===============================
resource "aws_subnet" "tf_public_subnet1" {
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id     = aws_vpc.tf_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Terraform-Subnet1"
  }
}

#Create subnet # 2 in us-east-2 
#===============================
resource "aws_subnet" "tf_public_subnet2" {
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id     = aws_vpc.tf_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "Terraform-Subnet2"
  }
}

# Subnet Associations
#======================
resource "aws_route_table_association" "tf_public1_assoc" {
  subnet_id      = aws_subnet.tf_public_subnet1.id
  route_table_id = aws_route_table.tf_public_route.id
}

resource "aws_route_table_association" "tf_public2_assoc" {
  subnet_id      = aws_subnet.tf_public_subnet2.id
  route_table_id = aws_route_table.tf_public_route.id
}

#Create SG for allowing all ports
#===================================
resource "aws_security_group" "tf_public_sg" {
  name        = "tf_public_sg"
  description = "Used for access to the public instances"
  vpc_id      = aws_vpc.tf_vpc.id
  #Inbound internet access
  #SSH

  #HTTP
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Terraform-SecurityGroup"
  }
}

#Create SG for allowing all ports
#===================================
#resource "aws_security_group" "tf_public_sg" {
#  name        = "tf_public_sg"
#  description = "Used for access to the public instances"
#  vpc_id      = aws_vpc.tf_vpc.id

  #Kubernetes All
#  ingress {
#    from_port   = 6443
#    to_port     = 6443
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

#  ingress {
#    from_port   = 443
#    to_port     = 443
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
  #Kubernetes API Server, etcd
#  ingress {
#    from_port   = 2379
#    to_port     = 2380
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

  #Kubelet API - Self, Control plane
#  ingress {
#    from_port   = 10250
#    to_port     = 10252
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

  #NodePort Service - All

# ingress {
#    from_port   = 30000
#    to_port     = 32767
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

#  ingress {
#    from_port   = 80
#    to_port     = 80
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#  ingress {
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
  
  #Outbound internet access
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#  tags = {
#    Name = "Terraform-SecurityGroup"
# }
#}