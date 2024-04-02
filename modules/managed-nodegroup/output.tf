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

output "capacity_type" {
  value = var.capacity_type
}

output "instance_types" {
  value = var.instance_types
}

output "ebs_volume_size" {
  value = var.ebs_volume_size
}
