provider "aws" {
  region = local.region
}

locals {
  region      = "us-east-1"
  environment = "dev"
  name        = "skaf"
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source = "git@gitlab.com:squareops/sal/terraform/aws/network.git?ref=qa"

  environment           = local.environment
  name                  = local.name
  region                = local.region
  azs                   = [for n in range(0, 3) : data.aws_availability_zones.available.names[n]]
  vpc_cidr              = "10.0.0.0/16"
  enable_public_subnet  = true
  enable_private_subnet = true
}


module "eks" {
  source = "../../"

  region                               = local.region
  environment                          = local.environment
  name                                 = local.name
  cluster_enabled_log_types            = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cluster_version                      = "1.21"
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  public_key_eks                       = var.key_pair_name
  vpc_id                               = module.vpc.vpc_id
  private_subnet_ids                   = module.vpc.private_subnets
  cert_manager_enabled                 = true
  cert_manager_version                 = "1.0.3"
  cert_manager_email                   = "support@example.com"
  cluster_autoscaler_version           = "1.1.0"
  metrics_server_version               = "6.0.5"
  ingress_nginx_enabled                = true
  ingress_nginx_version                = "3.10.1"
  aws_load_balancer_version            = "1.0.0"

}

module "managed_node_group_infra" {
  source = "../../node-groups/managed-nodegroup?ref=qa"

  name                   = "infra-ng"
  instance_types         = ["t3a.medium"]
  cluster_id             = module.eks.cluster_name
  public_key_eks         = var.key_pair_name
  desired_capacity_infra = 1
  subnet_ids             = module.vpc.private_subnets
  worker_iam_role_arn    = module.eks.worker_iam_role_arn
  kms_key_id             = var.key_arn
  k8s_labels = {
    "Infra-Services" = "true"
  }
}

module "managed_node_group_app" {
  source = "../../node-groups/managed-nodegroup?ref=qa"

  name                   = "app-ng"
  instance_types         = ["t3a.medium"]
  cluster_id             = module.eks.cluster_name
  public_key_eks         = var.key_pair_name
  desired_capacity_infra = 1
  subnet_ids             = module.vpc.private_subnets
  worker_iam_role_arn    = module.eks.worker_iam_role_arn
  kms_key_id             = var.key_arn
  k8s_labels = {
    "App-On-Demand" = "true"
  }
}
