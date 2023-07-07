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

resource "aws_iam_role" "cluster_role" {
  name = "AmazonEKSExampleClusterRole"

  assume_role_policy = file("./policies/eks-cluster-role-trust-policy.json")
}

resource "aws_iam_role_policy_attachment" "cluster_role_attachment" {
  role       = aws_iam_role.cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "main" {
  name     = local.eks_cluster_name
  role_arn = aws_iam_role.cluster_role.arn

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
    aws_iam_role_policy_attachment.cluster_role_attachment,
  ]
}

resource "aws_iam_role" "pod_execution_role" {
  name = "AmazonEKSFargatePodExecutionRole"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Condition" : {
            "ArnLike" : {
              "aws:SourceArn" : "arn:aws:eks:${local.region}:${local.account_id}:fargateprofile/${aws_eks_cluster.main.name}/*"
            }
          },
          "Principal" : {
            "Service" : "eks-fargate-pods.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "pod_execution_role_attachment" {
  role       = aws_iam_role.pod_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

resource "aws_eks_fargate_profile" "example" {
  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = "profile_example"
  pod_execution_role_arn = aws_iam_role.pod_execution_role.arn
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id,
    aws_subnet.private_3.id,
  ]

  selector {
    namespace = "default"
  }
}
