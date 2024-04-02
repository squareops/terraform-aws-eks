output "node_group_arn" {
  value = var.aws_managed_node_group_arm64 ? aws_eks_node_group.managed_ng[0].arn : null
}

output "min_node" {
  value = var.min_size
}

output "max_node" {
  value = var.max_size
}

output "desired_node" {
  value = var.desired_size
}

output "capacity_type" {
  value = var.capacity_type
}

output "instance_types" {
  value = var.instance_types
}

output "ebs_volume_size" {
  value = var.ebs_volume_size
}
