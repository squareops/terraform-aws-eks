data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
}

data "aws_ami" "launch_template_ami" {
  owners      = ["602401143452"]
  most_recent = true

  filter {
    name   = "name"
    values = [format("%s-%s-%s", "amazon-eks-node", data.aws_eks_cluster.eks.version, "v*")]
  }
}

data "aws_iam_policy" "SSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "SSMManagedInstanceCore_attachment" {
  role       = var.worker_iam_role_name
  policy_arn = data.aws_iam_policy.SSMManagedInstanceCore.arn
}

resource "aws_iam_policy" "node_autoscaler_policy" {
  name        = format("%s-%s-%s-node-autoscaler-policy", var.environment, var.name, var.eks_cluster_name)
  path        = "/"
  description = "Node auto scaler policy for node groups."
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "node_autoscaler_policy" {
  policy_arn = aws_iam_policy.node_autoscaler_policy.arn
  role       = var.worker_iam_role_name
}

resource "aws_iam_role_policy_attachment" "eks_kms_worker_policy_attachment" {
  role       = var.worker_iam_role_name
  policy_arn = var.kms_policy_arn
}

resource "aws_iam_role_policy_attachment" "eks_worker_policy" {
  role       = var.worker_iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = var.worker_iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_worker_ecr_policy" {
  role       = var.worker_iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "template_file" "launch_template_userdata" {
  template = file("${path.module}/templates/custom-bootstrap-script.sh.tpl")

  vars = {
    cluster_name                 = var.eks_cluster_name
    endpoint                     = data.aws_eks_cluster.eks.endpoint
    cluster_auth_base64          = data.aws_eks_cluster.eks.certificate_authority[0].data
    image_high_threshold_percent = var.image_high_threshold_percent
    image_low_threshold_percent  = var.image_low_threshold_percent
    eventRecordQPS               = var.eventRecordQPS
  }
}

resource "aws_launch_template" "eks_template" {
  name                   = format("%s-%s-%s", var.environment, var.name, "launch-template")
  update_default_version = true
  key_name               = var.eks_nodes_keypair
  user_data              = base64encode(data.template_file.launch_template_userdata.rendered)
  image_id               = data.aws_ami.launch_template_ami.image_id
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

  node_group_name = format("%s-%s-%s", var.environment, var.name, "ng")
  cluster_name    = var.eks_cluster_name
  node_role_arn   = var.worker_iam_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  labels = var.k8s_labels

  instance_types = var.instance_types
  capacity_type  = var.capacity_type


  launch_template {
    id      = aws_launch_template.eks_template.id
    version = aws_launch_template.eks_template.latest_version
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      scaling_config[0].desired_size,
    ]
  }

  tags = {
    Name        = format("%s-%s-%s", var.environment, var.name, "ng")
    Environment = var.environment
  }
}
