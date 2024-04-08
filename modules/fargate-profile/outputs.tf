output "fargate_profile_ids" {
  description = "EKS Cluster name and EKS Fargate Profile names separated by a colon (:)."
  value       = aws_eks_fargate_profile.eks_fargate_profile.id
}

output "fargate_profile_arns" {
  description = "Amazon Resource Name (ARN) of the EKS Fargate Profile."
  value       = aws_eks_fargate_profile.eks_fargate_profile.arn
}

output "iam_role_name" {
  description = "IAM role name for EKS Fargate pods"
  value       = aws_iam_role.eks_fargate_pod.name
}

output "iam_role_arn" {
  description = "IAM role ARN for EKS Fargate pods"
  value       = aws_iam_role.eks_fargate_pod.arn
}
