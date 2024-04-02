output "region" {
  description = "AWS region in which the EKS cluster is created."
  value       = local.region
}

output "cluster_name" {
  description = "Name of the Kubernetes cluster."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint URL for the EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group IDs that are attached to the control plane of the EKS cluster."
  value       = module.eks.cluster_security_group_id
}

output "cluster_arn" {
  description = "ARN of the EKS Cluster."
  value       = module.eks.cluster_arn
}

output "cluster_oidc_issuer_url" {
  description = "URL of the OpenID Connect identity provider on the EKS cluster."
  value       = module.eks.cluster_oidc_issuer_url
}

output "worker_iam_role_arn" {
  description = "ARN of the IAM role assigned to the EKS worker nodes."
  value       = module.eks.worker_iam_role_arn
}

output "worker_iam_role_name" {
  description = "Name of the IAM role assigned to the EKS worker nodes."
  value       = module.eks.worker_iam_role_name
}

output "kms_policy_arn" {
  description = "ARN of the KMS policy that is used by the EKS cluster."
  value       = module.eks.kms_policy_arn
}

# Managed Nodegroup amd64
output "managed_ng_node_group_arn" {
  description = "ARN for the nodegroup"
  value       = local.aws_managed_node_group_amd64 ? module.managed_node_group_production.node_group_arn : null
}

output "managed_ng_min_node" {
  description = "Minimum node of managed node group"
  value       = local.aws_managed_node_group_amd64 ? module.managed_node_group_production.min_node : null
}

output "managed_ng_max_node" {
  description = "Maximum node of managed node group"
  value       = local.aws_managed_node_group_amd64 ? module.managed_node_group_production.max_node : null
}

output "managed_ng_desired_node" {
  description = "Desired node of managed node group"
  value       = local.aws_managed_node_group_amd64 ? module.managed_node_group_production.desired_node : null
}

output "managed_ng_capacity_type" {
  description = "Capacity type of managed node"
  value       = local.aws_managed_node_group_amd64 ? module.managed_node_group_production.capacity_type : null
}

output "managed_ng_instance_types" {
  description = "Instance types of managed node "
  value       = local.aws_managed_node_group_amd64 ? module.managed_node_group_production.instance_types : null
}

output "managed_ng_disk_size" {
  description = "Disk size of node in managed node group"
  value       = local.aws_managed_node_group_amd64 ? module.managed_node_group_production.ebs_volume_size : null
}

# Managed Nodegroup arm64

output "arm_managed_ng_node_group_arn" {
  description = "ARN for the nodegroup"
  value       = local.aws_managed_node_group_arm64 ? module.graviton_managed_node_group_production.node_group_arn : null
}

output "arm_managed_ng_min_node" {
  description = "Minimum node of managed node group"
  value       = local.aws_managed_node_group_arm64 ? module.graviton_managed_node_group_production.min_node : null
}

output "arm_managed_ng_max_node" {
  description = "Maximum node of managed node group"
  value       = local.aws_managed_node_group_arm64 ? module.graviton_managed_node_group_production.max_node : null
}

output "arm_managed_ng_desired_node" {
  description = "Desired node of managed node group"
  value       = local.aws_managed_node_group_arm64 ? module.graviton_managed_node_group_production.desired_node : null
}

output "arm_managed_ng_capacity_type" {
  description = "Capacity type of managed node"
  value       = local.aws_managed_node_group_arm64 ? module.graviton_managed_node_group_production.capacity_type : null
}

output "arm_managed_ng_instance_types" {
  description = "Instance types of managed node "
  value       = local.aws_managed_node_group_arm64 ? module.graviton_managed_node_group_production.instance_types : null
}

output "arm_managed_ng_disk_size" {
  description = "Disk size of node in managed node group"
  value       = local.aws_managed_node_group_arm64 ? module.graviton_managed_node_group_production.ebs_volume_size : null
}

# default Nodegroup
output "default_ng_node_group_arn" {
  description = "ARN for the nodegroup"
  value       = local.default_addon_enabled ? module.eks.default_ng_node_group_arn : null
}

output "default_ng_min_node" {
  value = local.default_addon_enabled ? module.eks.default_ng_min_node : null
}

output "default_ng_max_node" {
  value = local.default_addon_enabled ? module.eks.default_ng_max_node : null
}

output "default_ng_desired_node" {
  value = local.default_addon_enabled ? module.eks.default_ng_desired_node : null
}

output "default_ng_capacity_type" {
  value = local.default_addon_enabled ? module.eks.default_ng_capacity_type : null
}

output "default_ng_instance_types" {
  value = local.default_addon_enabled ? module.eks.default_ng_instance_types : null
}

output "default_ng_ebs_volume_size" {
  value = local.default_addon_enabled ? module.eks.default_ng_ebs_volume_size : null
}
