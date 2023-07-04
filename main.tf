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