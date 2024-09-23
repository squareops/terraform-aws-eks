locals {
  launch_template_name = format("%s-%s-%s", var.eks_cluster_name, var.managed_ng_name, "lt")
  ami_owner            = var.enable_bottlerocket_ami ? "amazon" : "602401143452"
  ami_base_name        = var.enable_bottlerocket_ami ? "bottlerocket-aws-k8s" : (var.aws_managed_node_group_arch == "arm64" ? "amazon-eks-arm64-node" : "amazon-eks-node")
  ami_arch             = var.enable_bottlerocket_ami ? (var.aws_managed_node_group_arch == "arm64" ? "aarch64*" : "x86_64*") : "v*"
}

data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
}

data "aws_ami" "launch_template_ami" {
  owners      = [local.ami_owner]
  most_recent = true
  filter {
    name   = "name"
    values = [format("%s-%s-%s", local.ami_base_name, data.aws_eks_cluster.eks.version, local.ami_arch)]
  }
}

data "template_file" "launch_template_userdata" {
  count    = var.enable_bottlerocket_ami ? 0 : 1
  template = file("${path.module}/templates/${data.aws_eks_cluster.eks.kubernetes_network_config[0].ip_family == "ipv4" ? "custom-bootstrap-script.sh.tpl" : "custom-bootstrap-scriptipv6.sh.tpl"}")

  vars = {
    endpoint                     = data.aws_eks_cluster.eks.endpoint
    cluster_name                 = var.eks_cluster_name
    eventRecordQPS               = var.eventRecordQPS
    cluster_auth_base64          = data.aws_eks_cluster.eks.certificate_authority[0].data
    image_low_threshold_percent  = var.image_low_threshold_percent
    image_high_threshold_percent = var.image_high_threshold_percent
    managed_ng_pod_capacity      = var.managed_ng_pod_capacity
  }
}

data "template_file" "launch_template_userdata_bottlerocket" {
  count = var.enable_bottlerocket_ami ? 1 : 0

  template = file("${path.module}/templates/bootstrap-bottlerocket.toml.tpl")

  vars = {
    cluster_name                 = var.eks_cluster_name
    cluster_endpoint             = data.aws_eks_cluster.eks.endpoint
    cluster_ca_data              = data.aws_eks_cluster.eks.certificate_authority[0].data
    eventRecordQPS               = var.eventRecordQPS
    image_low_threshold_percent  = var.image_low_threshold_percent
    image_high_threshold_percent = var.image_high_threshold_percent
    managed_ng_pod_capacity      = var.managed_ng_pod_capacity
    admin_container_enabled      = var.bottlerocket_node_config.bottlerocket_eks_node_admin_container_enabled
    enable_control_container     = var.bottlerocket_node_config.bottlerocket_eks_enable_control_container
  }
}

resource "aws_launch_template" "eks_template" {
  name                   = length(var.launch_template_name) > 0 ? var.launch_template_name : local.launch_template_name
  key_name               = var.eks_nodes_keypair_name
  image_id               = data.aws_ami.launch_template_ami.image_id
  user_data              = var.enable_bottlerocket_ami ? base64encode(data.template_file.launch_template_userdata_bottlerocket[0].rendered) : base64encode(data.template_file.launch_template_userdata[0].rendered)
  update_default_version = true
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.managed_ng_ebs_volume_size
      volume_type           = var.managed_ng_ebs_volume_type
      delete_on_termination = var.managed_ng_volume_delete_on_termination
      encrypted             = var.managed_ng_ebs_encrypted
      kms_key_id            = var.managed_ng_kms_key_arn
    }
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    delete_on_termination       = var.managed_ng_network_interfaces_delete_on_termination
  }

  monitoring {
    enabled = var.managed_ng_monitoring_enabled
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = format("%s-%s-%s", var.environment, var.managed_ng_name, "eks-node")
      Environment = var.environment
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eks_node_group" "managed_ng" {
  subnet_ids      = var.vpc_subnet_ids
  cluster_name    = var.eks_cluster_name
  node_role_arn   = var.worker_iam_role_arn
  node_group_name = format("%s-%s-%s", var.environment, var.managed_ng_name, "ng")
  scaling_config {
    desired_size = var.managed_ng_desired_size
    max_size     = var.managed_ng_max_size
    min_size     = var.managed_ng_min_size
  }
  labels               = var.k8s_labels
  capacity_type        = var.managed_ng_capacity_type
  instance_types       = var.managed_ng_instance_types
  force_update_version = true
  launch_template {
    id      = aws_launch_template.eks_template.id
    version = aws_launch_template.eks_template.latest_version
  }
  update_config {
    max_unavailable_percentage = 50
  }
  tags = {
    Name        = format("%s-%s-%s", var.environment, var.managed_ng_name, "ng")
    Environment = var.environment
  }
}
