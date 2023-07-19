resource "aws_iam_policy" "load_balancer_controller_policy" {
  name = "AWSLoadBalancerControllerIAMPolicy"

  policy = file("${path.module}/policies/aws-load-balancer-controller-iam-policy.json")
}

locals {
  oidc_id = split("/", local.oidc_url).4
}

resource "aws_iam_role" "load_balancer_controller_role" {
  name = "AmazonEKSLoadBalancerControllerRole"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Federated" : "arn:aws:iam::${local.account_id}:oidc-provider/oidc.eks.${local.region}.amazonaws.com/id/${local.oidc_id}"
          },
          "Action" : "sts:AssumeRoleWithWebIdentity",
          "Condition" : {
            "StringEquals" : {
              "oidc.eks.${local.region}.amazonaws.com/id/${local.oidc_id}:aud" : "sts.amazonaws.com",
              "oidc.eks.${local.region}.amazonaws.com/id/${local.oidc_id}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
            }
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "load_balancer_controller_role_attachment" {
  role       = aws_iam_role.load_balancer_controller_role.name
  policy_arn = aws_iam_policy.load_balancer_controller_policy.arn
}
