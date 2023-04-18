output "region" {
  description = "AWS Region"
  value       = local.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "cluster_arn" {
  description = "ARN of EKS Cluster"
  value       = module.eks.cluster_arn
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.eks.cluster_oidc_issuer_url
}

output "worker_iam_role_arn" {
  description = "ARN of the EKS Worker Role"
  value       = module.eks.worker_iam_role_arn
}

output "worker_iam_role_name" {
  description = "The name of the EKS Worker IAM role"
  value       = module.eks.worker_iam_role_name
}

output "kms_policy_arn" {
  description = "ARN of KMS policy"
  value       = module.eks.kms_policy_arn
}
