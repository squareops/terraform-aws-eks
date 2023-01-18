module "eks" {
  source                    = "terraform-aws-modules/eks/aws"
  version                   = "18.29.0"
  cluster_name              = format("%s-%s", var.environment, var.name)
  cluster_enabled_log_types = var.cluster_enabled_log_types
  subnet_ids                = var.private_subnet_ids
  cluster_version           = var.cluster_version
  enable_irsa               = true

  tags = {
    "Name"        = format("%s-%s", var.environment, var.name)
    "Environment" = var.environment
  }

  vpc_id                                 = var.vpc_id
  cloudwatch_log_group_retention_in_days = var.cluster_log_retention_in_days
  cluster_endpoint_private_access        = var.cluster_endpoint_public_access ? false : true
  cluster_endpoint_public_access         = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs   = var.cluster_endpoint_public_access_cidrs

  cluster_encryption_config = [
    {
      provider_key_arn = var.kms_key_id
      resources        = ["secrets"]
    }
  ]
}

resource "aws_iam_role_policy_attachment" "eks_kms_cluster_policy_attachment" {
  role       = module.eks.cluster_iam_role_name
  policy_arn = var.kms_policy_arn
}


# resource "null_resource" "get_kubeconfig" {
#   depends_on = [module.eks]

#   provisioner "local-exec" {
#     command = "aws eks update-kubeconfig --name ${module.eks.cluster_id} --region ${var.region}"
#   }
# }

# role for node group
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
# node role policy

# resource "aws_iam_role_policy" "node_role_policy" {
#  name = format("%s-%s-node-role-policy", var.environment, var.name)
#  role = "${aws_iam_role.node_role.id}"
#  policy = <<-EOF
#  {
#    "Version": "2012-10-17",
#    "Statement": [
#      {
#        "Sid": "AccessObject",
#        "Effect": "Allow",
#        "Action": [
#           "s3:ListBucket",
#           "s3:GetObject",
#           "s3:DeleteObject",
#           "s3:PutObject",
#           "s3:AbortMultipartUpload",
#           "s3:ListMultipartUploadParts"
#        ],
#       "Resource": [
#          "${var.bucket_arn}",
#          "${var.bucket_arn}/*"
#       ]
#      }
#    ]
#  }
# EOF
# }
