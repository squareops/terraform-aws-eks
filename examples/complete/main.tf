locals {
  aws_region                               = "us-east-1"
  aws_account_id                           = ""
  kms_deletion_window_in_days              = 7
  key_rotation_enabled                     = true
  is_enabled                               = true
  multi_region                             = true
  environment                              = "prod"
  name                                     = "eks"
  vpc_availability_zones                   = ["us-east-1a", "us-east-1b"]
  vpc_public_subnet_enabled                = true
  vpc_private_subnet_enabled               = true
  database_subnet_enabled                  = false
  vpc_intra_subnet_enabled                 = false
  vpc_one_nat_gateway_per_az               = true
  vpn_server_instance_type                 = "t3a.small"
  vpc_flow_log_enabled                     = false
  kms_user                                 = null
  vpc_cidr                                 = "10.10.0.0/16"
  vpn_server_enabled                       = false
  default_addon_enabled                    = false
  eks_cluster_version                      = "1.27"
  eks_cluster_log_types                    = []
  eks_cluster_log_retention_in_days        = 30
  eks_capacity_type                        = "SPOT"
  managed_node_group_capacity_type         = "SPOT"
  eks_cluster_endpoint_public_access       = true
  eks_cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  create_aws_auth_configmap                = true
  node_group_ebs_volume_size               = 50
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
  enable_key_rotation     = local.key_rotation_enabled
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
  source                                          = "squareops/vpc/aws"
  environment                                     = local.environment
  name                                            = local.name
  vpc_cidr                                        = local.vpc_cidr
  availability_zones                              = local.vpc_availability_zones
  public_subnet_enabled                           = local.vpc_public_subnet_enabled
  private_subnet_enabled                          = local.vpc_private_subnet_enabled
  database_subnet_enabled                         = local.database_subnet_enabled
  intra_subnet_enabled                            = local.vpc_intra_subnet_enabled
  one_nat_gateway_per_az                          = local.vpc_one_nat_gateway_per_az
  vpn_server_enabled                              = local.vpn_server_enabled
  vpn_server_instance_type                        = local.vpn_server_instance_type
  vpn_key_pair_name                               = local.vpn_server_enabled ? module.key_pair_vpn[0].key_pair_name : null
  flow_log_enabled                                = local.vpc_flow_log_enabled
  flow_log_max_aggregation_interval               = 60
  flow_log_cloudwatch_log_group_retention_in_days = 90
  flow_log_cloudwatch_log_group_kms_key_arn       = module.kms.key_arn
}

module "eks" {
  source                                   = "squareops/eks/aws"
  depends_on                               = [module.vpc]
  name                                     = local.name
  vpc_id                                   = module.vpc.vpc_id
  vpc_subnet_ids                           = [module.vpc.private_subnets[0]]
  min_size                                 = 1
  max_size                                 = 3
  desired_size                             = 1
  ebs_volume_size                          = local.node_group_ebs_volume_size
  capacity_type                            = local.eks_capacity_type
  instance_types                           = ["t3a.large", "t2.large", "t2.xlarge", "t3.large", "m5.large"]
  environment                              = local.environment
  kms_key_arn                              = module.kms.key_arn
  eks_cluster_version                      = local.eks_cluster_version
  eks_cluster_log_types                    = local.eks_cluster_log_types
  vpc_private_subnet_ids                   = module.vpc.private_subnets
  eks_cluster_log_retention_in_days        = local.eks_cluster_log_retention_in_days
  eks_cluster_endpoint_public_access       = local.eks_cluster_endpoint_public_access
  eks_cluster_endpoint_public_access_cidrs = local.eks_cluster_endpoint_public_access_cidrs
  create_aws_auth_configmap                = local.create_aws_auth_configmap
  default_addon_enabled                    = local.default_addon_enabled
  eks_nodes_keypair_name                   = module.key_pair_eks.key_pair_name
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::222222222222:role/service-role"
      username = "username"
      groups   = ["system:masters"]
    }
  ]
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::222222222222:user/aws-user"
      username = "aws-user"
      groups   = ["system:masters"]
    },
  ]
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
  source                            = "squareops/eks/aws//modules/managed-nodegroup"
  depends_on                        = [module.vpc, module.eks]
  name                              = "Infra"
  min_size                          = 2
  max_size                          = 5
  desired_size                      = 2
  vpc_subnet_ids                    = [module.vpc.private_subnets[0]]
  environment                       = local.environment
  kms_key_arn                       = module.kms.key_arn
  managed_nodegroups_capacity_type  = local.managed_node_group_capacity_type
  ebs_volume_size                   = local.node_group_ebs_volume_size
  managed_nodegroups_instance_types = ["t3a.large", "t2.large", "t2.xlarge", "t3.large", "m5.large"]
  kms_policy_arn                    = module.eks.kms_policy_arn
  eks_cluster_name                  = module.eks.eks_cluster_name
  default_addon_enabled             = local.default_addon_enabled
  worker_iam_role_name              = module.eks.worker_iam_role_name
  worker_iam_role_arn               = module.eks.worker_iam_role_arn
  eks_nodes_keypair_name            = module.key_pair_eks.key_pair_name
  k8s_labels = {
    "Addons-Services" = "true"
  }
  tags = local.additional_aws_tags
}

module "farget_profle" {
  source       = "squareops/eks/aws//modules/fargate-profile"
  depends_on   = [module.vpc, module.eks]
  profile_name = local.fargate_profile_name
  subnet_ids   = [module.vpc.private_subnets[0]]
  environment  = local.environment
  cluster_name = module.eks.eks_cluster_name
  namespace    = ""
  labels = {
    "App-Services" = "fargate"
  }
}
