data "aws_subnet_ids" "private_subnet_ids" {
  vpc_id = var.vpc_id
  tags = {
    Subnet-group = "private"
  }
}

module "eks" {
  source                    = "terraform-aws-modules/eks/aws"
  version                   = "18.29.0"
  vpc_id                    = var.vpc_id
  enable_irsa               = true
  cluster_name              = format("%s-%s", var.environment, var.name)
  subnet_ids                = data.aws_subnet_ids.private_subnet_ids.ids
  cluster_enabled_log_types = var.cluster_log_types
  cluster_version           = var.cluster_version
  tags = {
    "Name"        = format("%s-%s", var.environment, var.name)
    "Environment" = var.environment
  }
  cluster_endpoint_private_access        = var.cluster_endpoint_public_access ? false : true
  cluster_endpoint_public_access         = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs   = var.cluster_endpoint_public_access_cidrs
  cloudwatch_log_group_retention_in_days = var.cluster_log_retention_in_days
  cluster_encryption_config = [
    {
      provider_key_arn = var.kms_key_arn
      resources        = ["secrets"]
    }
  ]
}

resource "aws_iam_policy" "kubernetes_pvc_kms_policy" {
  name        = format("%s-%s-%s", var.environment, var.name, "kubernetes-pvc-kms-policy")
  description = "Allow kubernetes pvc to get access of KMS."
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Effect": "Allow",
        "Action": [
            "kms:CreateGrant",
            "kms:Decrypt",
            "kms:GenerateDataKeyWithoutPlaintext"
        ],
        "Resource": "${var.kms_key_arn}"
      }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "eks_kms_cluster_policy_attachment" {
  role       = module.eks.cluster_iam_role_name
  policy_arn = aws_iam_policy.kubernetes_pvc_kms_policy.arn
}

resource "aws_iam_role" "node_role" {
  name               = format("%s-%s-node-role", var.environment, var.name)
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = merge(
    { "Name"        = format("%s-%s-node-role", var.environment, var.name)
      "Environment" = var.environment
    }
  )
}
