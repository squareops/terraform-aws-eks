output "cluster_name" {
  description = "Name of the Kubernetes cluster."
  value       = var.defaut_addon_enabled ? module.eks_addon[0].cluster_name : module.eks[0].cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint URL for the EKS control plane."
  value       = var.defaut_addon_enabled ? module.eks_addon[0].cluster_endpoint : module.eks[0].cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group IDs that are attached to the control plane of the EKS cluster."
  value       = var.defaut_addon_enabled ? module.eks_addon[0].cluster_primary_security_group_id : module.eks[0].cluster_primary_security_group_id
}

output "cluster_arn" {
  description = "ARN of the EKS Cluster."
  value       = var.defaut_addon_enabled ? module.eks_addon[0].cluster_arn : module.eks[0].cluster_arn
}

output "cluster_oidc_issuer_url" {
  description = "URL of the OpenID Connect identity provider on the EKS cluster."
  value       = var.defaut_addon_enabled ? module.eks_addon[0].cluster_oidc_issuer_url: module.eks[0].cluster_oidc_issuer_url
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

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = var.defaut_addon_enabled ? module.eks_addon[0].cluster_certificate_authority_data : module.eks[0].cluster_certificate_authority_data
}
