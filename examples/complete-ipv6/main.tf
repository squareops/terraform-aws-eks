locals {
  region      = "ap-south-1"
  environment = "stage"
  name        = "eks"
  additional_aws_tags = {
    Owner      = "SquareOps"
    Expires    = "Never"
    Department = "Engineering"
  }
  vpc_cidr           = "10.10.0.0/16"
  vpn_server_enabled = false
  ipv6_enabled = true
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
  source                                          = "git::https://github.com/yuvraj-squareops1/terraform-aws-vpc.git"
  environment                                     = local.environment
  name                                            = local.name
  vpc_cidr                                        = local.vpc_cidr
  availability_zones                              = 2
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
  ipv6_enabled = local.ipv6_enabled
  public_subnet_assign_ipv6_address_on_creation = true
  private_subnet_assign_ipv6_address_on_creation = true
  database_subnet_assign_ipv6_address_on_creation = true
  intra_subnet_assign_ipv6_address_on_creation = true 
}

module "eks" {
  source                               = "git::https://github.com/yuvraj-squareops1/terraform-aws-eks.git"
  depends_on                           = [module.vpc]
  name                                 = local.name
  vpc_id                               = module.vpc.vpc_id
  environment                          = local.environment
  kms_key_arn                          = "arn:aws:kms:ap-south-1:271251951598:key/3ca4d107-9545-427e-9305-3fdf15f6a97d"
  cluster_version                      = "1.25"
  cluster_log_types                    = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  private_subnet_ids                   = module.vpc.private_subnets
  cluster_log_retention_in_days        = 30
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  create_aws_auth_configmap            = true
  # aws_auth_roles = [
  #   {
  #     rolearn  = "arn:aws:iam::222222222222:role/service-role"
  #     username = "username"
  #     groups   = ["system:masters"]
  #   }
  # ]
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::271251951598:user/yuvraj-aws-skaf"
      username = "yuvraj-aws-skaf"
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
      cidr_blocks = ["172.10.0.0/16"]
    }
  }
  ipv6_enabled = local.ipv6_enabled
}

module "managed_node_group_production" {
  source                 = "git::https://github.com/yuvraj-squareops1/terraform-aws-eks.git//modules/managed-nodegroup"
  depends_on             = [module.vpc, module.eks]
  name                   = "Infra"
  min_size               = 1
  max_size               = 3
  desired_size           = 1
  subnet_ids             = [module.vpc.private_subnets[0]]
  environment            = local.environment
  kms_key_arn            = "arn:aws:kms:ap-south-1:271251951598:key/3ca4d107-9545-427e-9305-3fdf15f6a97d"
  capacity_type          = "ON_DEMAND"
  instance_types         = ["t3a.large", "t3.large", "m5.large"]
  kms_policy_arn         = module.eks.kms_policy_arn
  eks_cluster_name       = module.eks.cluster_name
  worker_iam_role_name   = module.eks.worker_iam_role_name
  eks_nodes_keypair_name = module.key_pair_eks.key_pair_name
  k8s_labels = {
    "Infra-Services" = "true"
  }
  tags = local.additional_aws_tags
}
