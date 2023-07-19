resource "aws_eks_fargate_profile" "core_dns" {
  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = "core_dns_profile"
  pod_execution_role_arn = aws_iam_role.pod_execution_role.arn
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id,
    aws_subnet.private_3.id,
  ]

  selector {
    namespace = "kube-system"
    labels = {
      "k8s-app" = "kube-dns"
    }
  }
}
