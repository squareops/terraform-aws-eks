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

output "key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = module.kms.key_arn
}

output "key_id" {
  description = "The globally unique identifier for the key"
  value       = module.kms.key_id
}

output "key_policy" {
  description = "The IAM resource policy set on the key"
  value       = module.kms.key_policy
}