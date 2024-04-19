output "eks_cluster_name" {
  description = "Name of the Kubernetes cluster."
  value       = var.eks_default_addon_enabled ? module.eks_addon[0].cluster_name : module.eks[0].cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint URL for the EKS control plane."
  value       = var.eks_default_addon_enabled ? module.eks_addon[0].cluster_endpoint : module.eks[0].cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "Security group IDs that are attached to the control plane of the EKS cluster."
  value       = var.eks_default_addon_enabled ? module.eks_addon[0].cluster_primary_security_group_id : module.eks[0].cluster_primary_security_group_id
}

output "eks_cluster_arn" {
  description = "ARN of the EKS Cluster."
  value       = var.eks_default_addon_enabled ? module.eks_addon[0].cluster_arn : module.eks[0].cluster_arn
}

output "eks_cluster_oidc_issuer_url" {
  description = "URL of the OpenID Connect identity provider on the EKS cluster."
  value       = var.eks_default_addon_enabled ? module.eks_addon[0].cluster_oidc_issuer_url : module.eks[0].cluster_oidc_issuer_url
}

output "worker_iam_role_arn" {
  description = "ARN of the IAM role assigned to the EKS worker nodes."
  value       = aws_iam_role.node_role.arn
}

output "worker_iam_role_name" {
  description = "Name of the IAM role assigned to the EKS worker nodes."
  value       = aws_iam_role.node_role.name
}

output "kms_policy_arn" {
  value       = aws_iam_policy.kubernetes_pvc_kms_policy.arn
  description = "ARN of the KMS policy that is used by the EKS cluster."
}

output "eks_cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = var.eks_default_addon_enabled ? module.eks_addon[0].cluster_certificate_authority_data : module.eks[0].cluster_certificate_authority_data
}

output "default_ng_node_group_arn" {
  description = "ARN for the nodegroup"
  value       = var.eks_default_addon_enabled ? aws_eks_node_group.default_ng[0].arn : null
}

output "default_ng_min_node" {
  description = "The minimum number of worker nodes in the default node group of EKS Cluster."
  value       = var.eks_default_addon_enabled ? var.eks_ng_min_size : null
}

output "default_ng_max_node" {
  description = "The maximum number of worker nodes in the default node group of EKS Cluster."
  value       = var.eks_default_addon_enabled ? var.eks_ng_max_size : null
}

output "default_ng_desired_node" {
  description = "The desired number of worker nodes in the default node group of EKS Cluster."
  value       = var.eks_default_addon_enabled ? var.eks_ng_desired_size : null
}

output "default_ng_capacity_type" {
  description = "The capacity type of worker nodes in the default node group in the EKS Cluster."
  value       = var.eks_default_addon_enabled ? var.eks_ng_capacity_type : null
}

output "default_ng_instance_types" {
  description = "The instance type of worker nodes in the default node group in the EKS Cluster."
  value       = var.eks_default_addon_enabled ? var.eks_ng_instance_types : null
}

output "default_ng_ebs_volume_size" {
  description = "The size of the EBS volume attached to worker nodes in the default node group in the EKS Cluster."
  value       = var.eks_default_addon_enabled ? var.eks_ebs_volume_size : null
}
