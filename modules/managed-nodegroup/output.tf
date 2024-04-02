output "node_group_arn" {
  description = "The Amazon Resource Name (ARN) of the managed node group."
  value       = aws_eks_node_group.managed_ng.arn
}

output "managed_ng_min_node" {
  description = "The minimum number of nodes allowed in the managed node group."
  value       = var.managed_ng_min_size
}

output "managed_ng_max_node" {
  description = "The maximum number of nodes allowed in the managed node group."
  value       = var.managed_ng_max_size
}

output "managed_ng_desired_node" {
  description = "The desired number of nodes in the managed node group."
  value       = var.managed_ng_desired_size
}

output "managed_ng_capacity_type" {
  description = "The capacity type for the managed node group (e.g., ON_DEMAND, SPOT)."
  value       = var.managed_ng_capacity_type
}

output "managed_ng_instance_types" {
  description = "The instance types used by the managed node group."
  value       = var.managed_ng_instance_types
}

output "managed_ng_ebs_volume_size" {
  description = "The size of the EBS volume attached to each node in the managed node group."
  value       = var.managed_ng_ebs_volume_size
}
