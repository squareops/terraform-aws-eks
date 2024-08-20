locals {
  region      = "us-east-2"
  environment = "prod"
  name        = "eks"
  additional_aws_tags = {
    Owner      = "Organization_name"
    Expires    = "Never"
    Department = "Engineering"
    Product    = ""
    Environment = local.environment
  }
  kms_user              = null
  vpc_cidr              = "10.10.0.0/16"
  ipv6_enabled          = true
  vpn_server_enabled    = true
  default_addon_enabled = true
  current_identity      = data.aws_caller_identity.current.arn
}

data "aws_caller_identity" "current" {}

module "kms" {
  source = "terraform-aws-modules/kms/aws"

  deletion_window_in_days = 7
  description             = "Symetric Key to Enable Encryption at rest using KMS services."
  enable_key_rotation     = false
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = false

  # Policy
  enable_default_policy                  = true
  key_owners                             = [local.current_identity]
  key_administrators                     = local.kms_user == null ? ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling", "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS", local.current_identity] : local.kms_user
  key_users                              = local.kms_user == null ? ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling", "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS", local.current_identity] : local.kms_user
  key_service_users                      = local.kms_user == null ? ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling", "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS", local.current_identity] : local.kms_user
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
          identifiers = ["logs.${local.region}.amazonaws.com"]
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
  availability_zones                              = ["us-east-2a", "us-east-2b"]
  public_subnet_enabled                           = true
  private_subnet_enabled                          = true
  database_subnet_enabled                         = true
  intra_subnet_enabled                            = true
  one_nat_gateway_per_az                          = true
  vpn_server_enabled                              = local.vpn_server_enabled
  vpn_server_instance_type                        = "t3a.small"
  vpn_key_pair_name                               = local.vpn_server_enabled ? module.key_pair_vpn[0].key_pair_name : null
  flow_log_enabled                                = true
  flow_log_max_aggregation_interval               = 60
  flow_log_cloudwatch_log_group_retention_in_days = 90
  flow_log_cloudwatch_log_group_kms_key_arn       = "arn:aws:kms:us-east-2:222222222222:key/kms_key_arn"
  ipv6_enabled                                    = local.ipv6_enabled
  public_subnet_assign_ipv6_address_on_creation   = true
  private_subnet_assign_ipv6_address_on_creation  = true
  database_subnet_assign_ipv6_address_on_creation = true
  intra_subnet_assign_ipv6_address_on_creation    = true
}

module "eks" {
  source                               = "squareops/eks/aws"
  depends_on                           = [module.vpc]
  name                                 = local.name
  vpc_id                               = module.vpc.vpc_id
  subnet_ids                           = [module.vpc.private_subnets[0]]
  min_size                             = 2
  max_size                             = 5
  desired_size                         = 2
  ebs_volume_size                      = 50
  capacity_type                        = "ON_DEMAND"
  instance_types                       = ["t3a.large", "t2.large", "t2.xlarge", "t3.large", "m5.large"]
  environment                          = local.environment
  kms_key_arn                          = module.kms.key_arn
  cluster_version                      = "1.27"
  cluster_log_types                    = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  default_addon_enabled                = local.default_addon_enabled
  eks_nodes_keypair_name               = module.key_pair_eks.key_pair_name
  private_subnet_ids                   = module.vpc.private_subnets
  cluster_log_retention_in_days        = 30
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  create_aws_auth_configmap            = true
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
  additional_rules = {
    ingress_port_mgmt_tcp = {
      description = "mgmt vpc cidr"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = ["10.10.0.0/16"]
    }
  }
  ipv6_enabled = local.ipv6_enabled
}

module "managed_node_group_production" {
  source                  = "squareops/eks/aws//modules/managed-nodegroup"
  depends_on              = [module.vpc, module.eks]
  name                    = "Infra"
  min_size                = 1
  max_size                = 3
  desired_size            = 1
  subnet_ids              = [module.vpc.private_subnets[0]]
  environment             = local.environment
  kms_key_arn             = module.kms.key_arn
  capacity_type           = "ON_DEMAND"
  ebs_volume_size         = 50
  instance_types          = ["t3a.large", "t3.large", "m5.large"]
  kms_policy_arn          = module.eks.kms_policy_arn
  eks_cluster_name        = module.eks.cluster_name
  default_addon_enabled   = local.default_addon_enabled
  managed_ng_pod_capacity = 90
  worker_iam_role_name    = module.eks.worker_iam_role_name
  worker_iam_role_arn     = module.eks.worker_iam_role_arn
  eks_nodes_keypair_name  = module.key_pair_eks.key_pair_name
  k8s_labels = {
    "Addon-Services" = "true"
  }
  tags         = local.additional_aws_tags
  ipv6_enabled = local.ipv6_enabled
}

module "farget_profle" {
  source       = "squareops/eks/aws//modules/fargate-profile"
  depends_on   = [module.vpc, module.eks]
  profile_name = "app"
  subnet_ids   = [module.vpc.private_subnets[0]]
  environment  = local.environment
  cluster_name = module.eks.cluster_name
  namespace    = ""
  labels = {
    "App-Services" = "fargate"
  }
}
