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

resource "aws_iam_role" "main" {
  name = "AmazonEKSExampleClusterRole"

  assume_role_policy = file("./policies/eks-cluster-role-trust-policy.json")
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "main" {
  name     = "eks_example"
  role_arn = aws_iam_role.main.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.public_1.id,
      aws_subnet.private_1.id,
      aws_subnet.public_2.id,
      aws_subnet.private_2.id,
      aws_subnet.public_3.id,
      aws_subnet.private_3.id,
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.main,
  ]
}
