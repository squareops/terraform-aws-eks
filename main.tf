module "eks" {
  source                    = "terraform-aws-modules/eks/aws"
  version                   = "19.15.2"
  vpc_id                    = var.vpc_id
  subnet_ids                = var.private_subnet_ids
  enable_irsa               = true
  cluster_name              = format("%s-%s", var.environment, var.name)
  create_kms_key            = var.create_kms_key
  cluster_version           = var.cluster_version
  cluster_enabled_log_types = var.cluster_log_types
  tags = {
    "Name"        = format("%s-%s", var.environment, var.name)
    "Environment" = var.environment
  }
  aws_auth_roles                          = var.aws_auth_roles
  aws_auth_users                          = var.aws_auth_users
  create_aws_auth_configmap               = var.create_aws_auth_configmap
  manage_aws_auth_configmap               = var.create_aws_auth_configmap
  cluster_security_group_additional_rules = var.additional_rules
  cluster_endpoint_public_access          = var.cluster_endpoint_public_access
  cluster_endpoint_private_access         = var.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs    = var.cluster_endpoint_public_access_cidrs

  cloudwatch_log_group_retention_in_days  = var.cluster_log_retention_in_days
  cloudwatch_log_group_kms_key_id         = var.kms_key_arn
  cluster_encryption_config = {
    provider_key_arn = var.kms_key_arn
    resources        = ["secrets"]
  }
  cluster_ip_family = var.ipv6_enabled ? "ipv6" : null
  # fargate_profile_defaults = var.fargate_profile == false ? null :{
  #   iam_role_additional_policies = {
  #     additional = aws_iam_policy.fargate.arn
  #   }
  # }

  fargate_profiles = var.fargate_profile == false ? null : merge(
    {
      example = {
        name = "fargate"
        selectors = [
          {
            namespace = var.fargate_profile_namespace
            labels = {
              Application = var.app_fargate_label
            }
          }
          }
        ]
        # Using specific subnets instead of the subnets supplied for the cluster itself
        subnet_ids = [module.vpc.private_subnets[1]]

        tags = {
          Owner = "secondary"
        }
        timeouts = {
          create = "20m"
          delete = "20m"
        }
      }
    }
}
)

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
            "kms:Decrypt",
            "kms:CreateGrant",
            "kms:GenerateDataKeyWithoutPlaintext"
        ],
        "Resource": "${var.kms_key_arn}"
      }
  ]
}
EOF
}

resource "aws_iam_policy" "fargate" {
  name = format("%s-%s-%s", var.environment, var.name, "fargate")

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      }]
  })
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
