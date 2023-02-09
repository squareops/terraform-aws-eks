locals {
  region      = "us-east-2"
  environment = "prod"
  name        = "skaf"
  additional_aws_tags = {
    Owner      = "SquareOps"
    Expires    = "Never"
    Department = "Engineering"
  }
  vpc_cidr = "172.10.0.0/16"
}

data "aws_availability_zones" "available" {}

module "key_pair_vpn" {
  source             = "squareops/keypair/aws"
  environment        = local.environment
  key_name           = format("%s-%s-vpn", local.environment, local.name)
  ssm_parameter_path = format("%s-%s-vpn", local.environment, local.name)
}

module "key_pair_eks" {
  source             = "squareops/keypair/aws"
  environment        = local.environment
  key_name           = format("%s-%s-eks", local.environment, local.name)
  ssm_parameter_path = format("%s-%s-eks", local.environment, local.name)
}

module "vpc" {
  source = "squareops/vpc/aws"
  environment                                     = local.environment
  name                                            = local.name
  vpc_cidr                                        = local.vpc_cidr
  azs                                             = [for n in range(0, 2) : data.aws_availability_zones.available.names[n]]
  enable_public_subnet                            = true
  enable_private_subnet                           = true
  enable_database_subnet                          = true
  enable_intra_subnet                             = true
  one_nat_gateway_per_az                          = true
  vpn_server_enabled                              = true
  vpn_server_instance_type                        = "t3a.small"
  vpn_key_pair                                    = module.key_pair_vpn.key_pair_name
  enable_flow_log                                 = true
  flow_log_max_aggregation_interval               = 60
  flow_log_cloudwatch_log_group_retention_in_days = 90
}

module "eks" {
  source                               = "../../"
  environment                          = local.environment
  name                                 = local.name
  cluster_enabled_log_types            = ["api", "scheduler"]
  cluster_version                      = "1.23"
  cluster_log_retention_in_days        = 30
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  vpc_id                               = module.vpc.vpc_id
  private_subnet_ids                   = module.vpc.private_subnets
  kms_key_arn                           = ""
  kms_policy_arn                       = ""
}

module "managed_node_group_production" {
  source               = "../../node-groups/managed-nodegroup"
  name                 = "Infra"
  environment          = local.environment
  eks_cluster_id       = module.eks.cluster_name
  eks_nodes_keypair    = module.key_pair_eks.key_pair_name
  subnet_ids           = [module.vpc.private_subnets[0]]
  worker_iam_role_arn  = module.eks.worker_iam_role_arn
  worker_iam_role_name = module.eks.worker_iam_role_name
  kms_key_arn           = ""
  kms_policy_arn       = ""
  desired_size         = 1
  max_size             = 3
  instance_types       = ["t3a.xlarge"]
  capacity_type        = "ON_DEMAND"
  k8s_labels = {
    "Infra-Services" = "true"
  }

  tags = local.additional_aws_tags

}
