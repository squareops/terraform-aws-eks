locals {
  aws_region                               = "ap-northeast-1"
  aws_account_id                           = "767398031518"
  kms_deletion_window_in_days              = 7
  kms_key_rotation_enabled                 = true
  is_enabled                               = true
  multi_region                             = false
  environment                              = "stg"
  name                                     = "rachit"
  vpc_availability_zones                   = ["ap-northeast-1a", "ap-northeast-1c"]
  vpc_one_nat_gateway_per_az               = true
  vpc_flow_log_enabled                     = false
  kms_user                                 = null
  vpc_cidr                                 = "10.10.0.0/16"
  vpn_server_enabled                       = false
  eks_default_addon_enabled                = false
  eks_cluster_version                      = "1.29"
  eks_cluster_log_types                    = []
  eks_cluster_log_retention_in_days        = 30
  eks_capacity_type                        = "SPOT"
  managed_ng_capacity_type                 = "SPOT"
  eks_cluster_endpoint_public_access       = true
  eks_cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  eks_ebs_volume_size                      = 50
  fargate_profile_name                     = "app"
  current_identity                         = data.aws_caller_identity.current.arn
  additional_aws_tags = {
    Owner      = "Organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
}
data "aws_caller_identity" "current" {}

module "kms" {
  source = "terraform-aws-modules/kms/aws"

  deletion_window_in_days = local.kms_deletion_window_in_days
  description             = "Symetric Key to Enable Encryption at rest using KMS services."
  enable_key_rotation     = local.kms_key_rotation_enabled
  is_enabled              = local.is_enabled
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = local.multi_region

  # Policy
  enable_default_policy                  = true
  key_owners                             = [local.current_identity]
  key_administrators                     = local.kms_user == null ? ["arn:aws:iam::${local.aws_account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling", "arn:aws:iam::${local.aws_account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS", local.current_identity] : local.kms_user
  key_users                              = local.kms_user == null ? ["arn:aws:iam::${local.aws_account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling", "arn:aws:iam::${local.aws_account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS", local.current_identity] : local.kms_user
  key_service_users                      = local.kms_user == null ? ["arn:aws:iam::${local.aws_account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling", "arn:aws:iam::${local.aws_account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS", local.current_identity] : local.kms_user
  key_symmetric_encryption_users         = [local.current_identity]
  key_hmac_users                         = [local.current_identity]
  key_asymmetric_public_encryption_users = [local.current_identity]
  key_asymmetric_sign_verify_users       = [local.current_identity]
  key_statements = [
    {
      sid    = "AllowCloudWatchLogsEncryption",
      effect = "Allow"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = ["*"]

      principals = [
        {
          type        = "Service"
          identifiers = ["logs.${local.aws_region}.amazonaws.com"]
        }
      ]
    }
  ]
  # Aliases
  aliases                 = ["${local.name}-KMS"]
  aliases_use_name_prefix = true
}

module "key_pair_vpn" {
  source             = "squareops/keypair/aws"
  count              = local.vpn_server_enabled ? 1 : 0
  key_name           = format("%s-%s-vpn", local.environment, local.name)
  environment        = local.environment
  ssm_parameter_path = format("%s-%s-vpn", local.environment, local.name)
}

module "key_pair_eks" {
  source             = "squareops/keypair/aws"
  key_name           = format("%s-%s-eks", local.environment, local.name)
  environment        = local.environment
  ssm_parameter_path = format("%s-%s-eks", local.environment, local.name)
}

module "vpc" {
  source                                              = "squareops/vpc/aws"
  name                                                = "stg-rachit"
  aws_region                                          = local.aws_region
  vpc_cidr                                            = local.vpc_cidr
  environment                                         = local.environment
  vpc_flow_log_enabled                                = local.vpc_flow_log_enabled
  vpn_server_key_pair_name                            = local.vpn_server_enabled ? module.key_pair_vpn[0].key_pair_name : null
  vpc_availability_zones                              = local.vpc_availability_zones
  vpn_server_enabled                                  = false
  vpc_intra_subnet_enabled                            = true
  vpc_public_subnet_enabled                           = true
  auto_assign_public_ip                               = true
  vpc_private_subnet_enabled                          = true
  vpc_one_nat_gateway_per_az                          = true
  vpc_database_subnet_enabled                         = true
  vpn_server_instance_type                            = "t3a.small"
  vpc_s3_endpoint_enabled                             = true
  vpc_ecr_endpoint_enabled                            = true
  vpc_flow_log_max_aggregation_interval               = 60 # In seconds
  vpc_flow_log_cloudwatch_log_group_skip_destroy      = false
  vpc_flow_log_cloudwatch_log_group_retention_in_days = 90
  vpc_flow_log_cloudwatch_log_group_kms_key_arn       = module.kms.key_arn #Enter your kms key arn
  vpc_public_subnets_counts                           = 2
  vpc_private_subnets_counts                          = 2
  vpc_intra_subnets_counts                            = 2
  vpc_database_subnets_counts                         = 2
  vpc_endpoint_type_private_s3                        = "Gateway"
  vpc_endpoint_type_ecr_dkr                           = "Interface"
  vpc_endpoint_type_ecr_api                           = "Interface"
}

module "eks" {
  source               = "squareops/eks/aws"
  access_entry_enabled = false
  access_entries = {
    "example" = {
      kubernetes_groups = ["cluster-admins"]
      principal_arn     = "arn:aws:iam::767398031518:role/proddd-eks-cluster-20240326061022341800000006"
      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      }
    }
  }
  enable_cluster_creator_admin_permissions = true
  authentication_mode                      = "API_AND_CONFIG_MAP"
  depends_on                               = [module.vpc]
  name                                     = local.name
  vpc_id                                   = module.vpc.vpc_id
  vpc_subnet_ids                           = [module.vpc.vpc_private_subnets[0]]
  eks_ng_min_size                          = 1
  eks_ng_max_size                          = 3
  eks_ng_desired_size                      = 2
  eks_ebs_volume_size                      = local.eks_ebs_volume_size
  eks_ng_capacity_type                     = local.eks_capacity_type
  eks_ng_instance_types                    = ["t3a.large", "t2.large", "t2.xlarge", "t3.large", "m5.large"]
  environment                              = local.environment
  eks_kms_key_arn                          = module.kms.key_arn
  eks_cluster_version                      = local.eks_cluster_version
  eks_cluster_log_types                    = local.eks_cluster_log_types
  vpc_private_subnet_ids                   = module.vpc.vpc_private_subnets
  eks_cluster_log_retention_in_days        = local.eks_cluster_log_retention_in_days
  eks_cluster_endpoint_public_access       = local.eks_cluster_endpoint_public_access
  eks_cluster_endpoint_public_access_cidrs = local.eks_cluster_endpoint_public_access_cidrs
  eks_nodes_keypair_name                   = module.key_pair_eks.key_pair_name
  eks_cluster_security_group_additional_rules = {
    ingress_port_mgmt_tcp = {
      description = "mgmt vpc cidr"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = ["10.10.0.0/16"]
    }
  }
}

module "managed_node_group_production" {
  source                        = "squareops/eks/aws//modules/managed-nodegroup"
  depends_on                    = [module.vpc, module.eks]
  managed_ng_name               = "Infra"
  managed_ng_min_size           = 2
  managed_ng_max_size           = 2
  managed_ng_desired_size       = 2
  vpc_subnet_ids                = [module.vpc.vpc_private_subnets[0]]
  environment                   = local.environment
  managed_ng_kms_key_arn        = module.kms.key_arn
  managed_ng_capacity_type      = local.managed_ng_capacity_type
  managed_ng_ebs_volume_size    = local.eks_ebs_volume_size
  managed_ng_ebs_volume_type    = "gp3"
  managed_ng_ebs_encrypted      = true
  managed_ng_instance_types     = ["t3a.large", "t2.large", "t2.xlarge", "t3.large", "m5.large"]
  managed_ng_kms_policy_arn     = module.eks.kms_policy_arn
  eks_cluster_name              = module.eks.eks_cluster_name
  default_addon_enabled         = local.eks_default_addon_enabled
  worker_iam_role_name          = module.eks.worker_iam_role_name
  worker_iam_role_arn           = module.eks.worker_iam_role_arn
  eks_nodes_keypair_name        = module.key_pair_eks.key_pair_name
  managed_ng_monitoring_enabled = true
  k8s_labels = {
    "Addons-Services" = "true"
  }
  tags = local.additional_aws_tags
}

module "fargate_profle" {
  source               = "squareops/eks/aws//modules/fargate-profile"
  depends_on           = [module.vpc, module.eks]
  fargate_profile_name = local.fargate_profile_name
  fargate_subnet_ids   = [module.vpc.private_subnets[0]]
  environment          = local.environment
  eks_cluster_name     = module.eks.eks_cluster_name
  fargate_namespace    = "fargate"
  k8s_labels = {
    "App-Services" = "fargate"
  }
}
