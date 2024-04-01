output "node_group_arn" {
  value = aws_eks_node_group.managed_ng.arn
}

output "managed_ng_min_node" {
  value = var.managed_ng_min_size
}

output "managed_ng_max_node" {
  value = var.managed_ng_max_size
}

output "managed_ng_desired_node" {
  value = var.managed_ng_desired_size
}

output "managed_ng_capacity_type" {
  value = var.managed_ng_capacity_type
}

output "managed_ng_instance_types" {
  value = var.managed_ng_instance_types
}

output "managed_ng_ebs_volume_size" {
  value = var.managed_ng_ebs_volume_size
}
