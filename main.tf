terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = local.region
}

resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "eks_example"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "eks_example"
  }
}

resource "aws_eip" "nat_gateway_1" {
  tags = {
    Name = "eks_example_private_1"
  }
}

resource "aws_eip" "nat_gateway_2" {
  tags = {
    Name = "eks_example_private_2"
  }
}

resource "aws_eip" "nat_gateway_3" {
  tags = {
    Name = "eks_example_private_3"
  }
}

resource "aws_nat_gateway" "private_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "eks_example_private_1"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "private_2" {
  allocation_id = aws_eip.nat_gateway_2.id
  subnet_id     = aws_subnet.public_2.id

  tags = {
    Name = "eks_example_private_2"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "private_3" {
  allocation_id = aws_eip.nat_gateway_3.id
  subnet_id     = aws_subnet.public_3.id

  tags = {
    Name = "eks_example_private_3"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "eks_example_public"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_3" {
  subnet_id      = aws_subnet.public_3.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  availability_zone = local.availability_zone_1
  cidr_block        = "192.168.0.0/19"

  tags = {
    Name = "eks_example_public_1"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  availability_zone = local.availability_zone_1
  cidr_block        = "192.168.32.0/19"

  tags = {
    Name = "eks_example_private_1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = local.availability_zone_2
  cidr_block        = "192.168.64.0/19"

  tags = {
    Name = "eks_example_public_2"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = local.availability_zone_2
  cidr_block        = "192.168.96.0/19"

  tags = {
    Name = "eks_example_private_2"
  }
}

resource "aws_subnet" "public_3" {
  vpc_id            = aws_vpc.main.id
  availability_zone = local.availability_zone_3
  cidr_block        = "192.168.128.0/19"

  tags = {
    Name = "eks_example_public_3"
  }
}

resource "aws_subnet" "private_3" {
  vpc_id            = aws_vpc.main.id
  availability_zone = local.availability_zone_3
  cidr_block        = "192.168.160.0/19"

  tags = {
    Name = "eks_example_private_3"
  }
}
