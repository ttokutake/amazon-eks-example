data "aws_caller_identity" "current" {}

locals {
  region              = "ap-northeast-1"
  availability_zone_1 = "ap-northeast-1a"
  availability_zone_2 = "ap-northeast-1c"
  availability_zone_3 = "ap-northeast-1d"

  account_id = data.aws_caller_identity.current.account_id

  eks_cluster_name = "eks_example"
}
