output "node_group_arn" {
  value = aws_eks_node_group.managed_ng.arn
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

output "managed_nodegroups_capacity_type" {
  value = var.managed_nodegroups_capacity_type
}

output "managed_nodegroups_instance_types" {
  value = var.managed_nodegroups_instance_types
}

output "ebs_volume_size" {
  value = var.ebs_volume_size
}
