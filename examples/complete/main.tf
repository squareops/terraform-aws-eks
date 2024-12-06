locals {
  region                               = "us-west-1"
  kms_deletion_window_in_days          = 7
  kms_key_rotation_enabled             = true
  is_enabled                           = true
  multi_region                         = false
  environment                          = "stage"
  name                                 = "sqops"
  auto_assign_public_ip                = true
  vpc_availability_zones               = ["us-west-1a", "us-west-1b"]
  vpc_public_subnet_enabled            = true
  vpc_private_subnet_enabled           = true
  vpc_database_subnet_enabled          = true
  vpc_intra_subnet_enabled             = true
  vpc_one_nat_gateway_per_az           = true
  vpn_server_instance_type             = "t3a.small"
  vpc_flow_log_enabled                 = false
  kms_user                             = null
  vpc_cidr                             = "10.10.0.0/16"
  vpn_server_enabled                   = true
  cluster_version                      = "1.30"
  cluster_log_types                    = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cluster_log_retention_in_days        = 30
  managed_ng_capacity_type             = "SPOT" # Choose the capacity type ("SPOT" or "ON_DEMAND")
  cluster_endpoint_private_access      = false
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  ebs_volume_size                      = 50
  fargate_profile_name                 = "app"
  vpc_s3_endpoint_enabled              = true
  vpc_ecr_endpoint_enabled             = false
  vpc_public_subnets_counts            = 2
  vpc_private_subnets_counts           = 2
  vpc_database_subnets_counts          = 2
  vpc_intra_subnets_counts             = 2
  launch_template_name                 = "launch-template-name"
  additional_aws_tags = {
    Owner       = "Organization_name"
    Expires     = "Never"
    Department  = "Engineering"
    Product     = ""
    Environment = local.environment
  }
  aws_managed_node_group_arch = "amd64" #Enter your linux arch (Example:- arm64 or amd64)
  current_identity            = data.aws_caller_identity.current.arn
  enable_bottlerocket_ami     = false
}

data "aws_caller_identity" "current" {}

module "kms" {
  source                  = "terraform-aws-modules/kms/aws"
  version                 = "3.1.0"
  deletion_window_in_days = local.kms_deletion_window_in_days
  description             = "Symetric Key to Enable Encryption at rest using KMS services."
  enable_key_rotation     = local.kms_key_rotation_enabled
  is_enabled              = local.is_enabled
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = local.multi_region

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
  version            = "1.0.2"
  count              = local.vpn_server_enabled ? 1 : 0
  key_name           = format("%s-%s-vpn", local.environment, local.name)
  environment        = local.environment
  ssm_parameter_path = format("%s-%s-vpn", local.environment, local.name)
}

module "key_pair_eks" {
  source             = "squareops/keypair/aws"
  version            = "1.0.2"
  key_name           = format("%s-%s-eks", local.environment, local.name)
  environment        = local.environment
  ssm_parameter_path = format("%s-%s-eks", local.environment, local.name)
}

module "vpc" {
  source                                          = "squareops/vpc/aws"
  version                                         = "3.4.1"
  name                                            = local.name
  region                                          = local.region
  vpc_cidr                                        = local.vpc_cidr
  environment                                     = local.environment
  vpn_key_pair_name                               = local.vpn_server_enabled ? module.key_pair_vpn[0].key_pair_name : null
  availability_zones                              = local.vpc_availability_zones
  intra_subnet_enabled                            = local.vpc_intra_subnet_enabled
  public_subnet_enabled                           = local.vpc_public_subnet_enabled
  auto_assign_public_ip                           = local.auto_assign_public_ip
  private_subnet_enabled                          = local.vpc_private_subnet_enabled
  one_nat_gateway_per_az                          = local.vpc_one_nat_gateway_per_az
  database_subnet_enabled                         = local.vpc_database_subnet_enabled
  vpn_server_enabled                              = local.vpn_server_enabled
  vpn_server_instance_type                        = "t3a.small"
  vpc_s3_endpoint_enabled                         = local.vpc_s3_endpoint_enabled
  vpc_ecr_endpoint_enabled                        = local.vpc_ecr_endpoint_enabled
  flow_log_enabled                                = local.vpc_flow_log_enabled
  flow_log_max_aggregation_interval               = 60 # In seconds
  flow_log_cloudwatch_log_group_skip_destroy      = false
  flow_log_cloudwatch_log_group_retention_in_days = 90
  flow_log_cloudwatch_log_group_kms_key_arn       = module.kms.key_arn #Enter your kms key arn
}

module "eks" {
  source               = "squareops/eks/aws"
  version              = "5.2.0"
  access_entry_enabled = true
  access_entries = {
    "example" = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::381491984451:user/test-user"
      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
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
  environment                              = local.environment
  kms_key_arn                              = module.kms.key_arn
  cluster_version                          = local.cluster_version
  cluster_log_types                        = local.cluster_log_types
  vpc_private_subnet_ids                   = module.vpc.private_subnets
  cluster_log_retention_in_days            = local.cluster_log_retention_in_days
  cluster_endpoint_public_access           = local.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs     = local.cluster_endpoint_public_access_cidrs
  cluster_endpoint_private_access          = local.cluster_endpoint_private_access
  nodes_keypair_name                       = module.key_pair_eks.key_pair_name
  cluster_security_group_additional_rules = {
    ingress_port_mgmt_tcp = {
      description = "mgmt vpc cidr"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = ["10.10.0.0/16"]
    }
  }
  tags = local.additional_aws_tags
}

module "managed_node_group_addons" {
  source                        = "squareops/eks/aws//modules/managed-nodegroup"
  version                       = "5.2.0"
  depends_on                    = [module.vpc, module.eks]
  managed_ng_name               = "Infra"
  managed_ng_min_size           = 2
  managed_ng_max_size           = 5
  managed_ng_desired_size       = 2
  vpc_subnet_ids                = [module.vpc.private_subnets[0]]
  environment                   = local.environment
  managed_ng_kms_key_arn        = module.kms.key_arn
  managed_ng_capacity_type      = local.managed_ng_capacity_type
  managed_ng_ebs_volume_size    = local.ebs_volume_size
  managed_ng_ebs_volume_type    = "gp3"
  managed_ng_ebs_encrypted      = true
  managed_ng_instance_types     = ["t3a.large", "t2.large", "t2.xlarge", "t3.large", "m5.large"] # Pass instance type according to the ami architecture.
  managed_ng_kms_policy_arn     = module.eks.kms_policy_arn
  eks_cluster_name              = module.eks.cluster_name
  worker_iam_role_name          = module.eks.worker_iam_role_name
  worker_iam_role_arn           = module.eks.worker_iam_role_arn
  eks_nodes_keypair_name        = module.key_pair_eks.key_pair_name
  managed_ng_pod_capacity       = 90
  managed_ng_monitoring_enabled = true
  launch_template_name          = local.launch_template_name
  k8s_labels = {
    "Addons-Services" = "true"
  }
  tags                        = local.additional_aws_tags
  custom_ami_id               = "ami-0fa61e53a0b32612b"           # Optional, if not passed terraform will automatically select the latest supported ami id
  aws_managed_node_group_arch = local.aws_managed_node_group_arch # optional if "custom_ami_id" is passed
  enable_bottlerocket_ami     = local.enable_bottlerocket_ami     # Set it to false if using Amazon Linux AMIs
  bottlerocket_node_config = {
    bottlerocket_eks_node_admin_container_enabled = false
    bottlerocket_eks_enable_control_container     = true
  }
}

module "fargate_profle" {
  source               = "squareops/eks/aws//modules/fargate-profile"
  depends_on           = [module.vpc, module.eks]
  fargate_profile_name = local.fargate_profile_name
  fargate_subnet_ids   = [module.vpc.vpc_private_subnets[0]]
  environment          = local.environment
  eks_cluster_name     = module.eks.eks_cluster_name
  fargate_namespace    = "fargate"
  k8s_labels = {
    "App-Services" = "app"
  }
}
