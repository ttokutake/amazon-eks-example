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
