data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
}

data "aws_region" "current" {}

data "aws_ami" "launch_template_ami_amd64" {
  owners      = ["602401143452"]
  most_recent = true
  filter {
    name   = "name"
    values = [format("%s-%s-%s", "amazon-eks-node", data.aws_eks_cluster.eks.version, "v*")]
  }
}

data "aws_ami" "launch_template_ami_arm64" {
  owners      = ["602401143452"]
  most_recent = true
  filter {
    name   = "name"
    values = [format("%s-%s-%s", "amazon-eks-arm64-node", data.aws_eks_cluster.eks.version, "v*")]
  }
}

data "template_file" "launch_template_userdata" {
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

resource "aws_launch_template" "eks_template" {
  name                   = format("%s-%s-%s", var.environment, var.name, "launch-template")
  key_name               = var.eks_nodes_keypair_name
  image_id               = var.aws_managed_node_group_arch == "arm64" ? data.aws_ami.launch_template_ami_arm64.image_id : data.aws_ami.launch_template_ami_amd64.image_id
  user_data              = base64encode(data.template_file.launch_template_userdata.rendered)
  update_default_version = true
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.ebs_volume_size
      volume_type           = var.ebs_volume_type
      delete_on_termination = true
      encrypted             = var.ebs_encrypted
      kms_key_id            = var.kms_key_arn
    }
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    delete_on_termination       = true
  }

  monitoring {
    enabled = var.enable_monitoring
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = format("%s-%s-%s", var.environment, var.name, "eks-node")
      Environment = var.environment
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eks_node_group" "managed_ng" {
  subnet_ids      = var.subnet_ids
  cluster_name    = var.eks_cluster_name
  node_role_arn   = var.worker_iam_role_arn
  node_group_name = format("%s-%s-%s", var.environment, var.name, "ng")
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }
  labels               = var.k8s_labels
  capacity_type        = var.capacity_type
  instance_types       = var.instance_types
  force_update_version = true
  launch_template {
    id      = aws_launch_template.eks_template.id
    version = aws_launch_template.eks_template.latest_version
  }
  update_config {
    max_unavailable_percentage = 50
  }
  tags = {
    Name        = format("%s-%s-%s", var.environment, var.name, "ng")
    Environment = var.environment
  }
}
