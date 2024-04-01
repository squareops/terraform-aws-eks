data "aws_partition" "current" {}

data "aws_iam_policy_document" "eks_fargate_pod_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_fargate_pod" {
  name_prefix          = format("%s-%s-%s", var.environment, var.fargate_profile_name, "fargate")
  assume_role_policy   = data.aws_iam_policy_document.eks_fargate_pod_assume_role.json
  permissions_boundary = var.permissions_boundary
  tags = {
    Name        = format("%s-%s-%s", var.environment, var.fargate_profile_name, "fargate")
    Environment = var.environment
  }
  path = var.iam_path
}

resource "aws_iam_role_policy_attachment" "eks_fargate_pod" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks_fargate_pod.name
}

resource "aws_eks_fargate_profile" "eks_fargate_profile" {
  cluster_name           = var.eks_cluster_name
  fargate_profile_name   = format("%s-%s-%s", var.environment, var.fargate_profile_name, "fargate")
  pod_execution_role_arn = aws_iam_role.eks_fargate_pod.arn
  subnet_ids             = var.fargate_subnet_ids
  selector {
    namespace = var.fargate_namespace
    labels    = var.labels
  }

  tags = {
    Name        = format("%s-%s-%s", var.environment, var.fargate_profile_name, "fargate")
    Environment = var.environment
  }
}
