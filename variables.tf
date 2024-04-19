variable "additional_tags" {
  description = "Additional tags to be applied to AWS resources"
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "Name of the AWS region where S3 bucket is to be created."
  default     = "us-east-1"
  type        = string
}

variable "aws_account_id" {
  description = "Account ID of the AWS Account."
  default     = ""
  type        = string
}

variable "environment" {
  description = "Environment identifier for the EKS cluster, such as dev, qa, prod, etc."
  default     = ""
  type        = string
}

variable "name" {
  description = "Specify the name of the EKS cluster."
  default     = ""
  type        = string
}

variable "eks_cluster_version" {
  description = "Specifies the Kubernetes version (major.minor) to use for the EKS cluster."
  default     = ""
  type        = string
}

variable "irsa_enabled" {
  description = "Set to true to associate an AWS IAM role with a Kubernetes service account. "
  default     = true
  type        = bool
}

variable "eks_cluster_endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled or not."
  default     = true
  type        = bool
}


variable "eks_cluster_endpoint_public_access_cidrs" {
  description = "CIDR blocks that can access the Amazon EKS public API server endpoint."
  default     = [""]
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be deployed."
  default     = ""
  type        = string
}

variable "eks_kms_key_arn" {
  description = "ARN of the KMS key used to encrypt EKS resources."
  default     = ""
  type        = string
}

variable "eks_cluster_log_types" {
  description = "A list of desired control plane logs to enable for the EKS cluster. Valid values include: api, audit, authenticator, controllerManager, scheduler."
  default     = []
  type        = list(string)
}

variable "eks_cluster_log_retention_in_days" {
  description = "Retention period for EKS cluster logs in days. Default is set to 90 days."
  default     = 90
  type        = number
}

variable "vpc_private_subnet_ids" {
  description = "Private subnets of the VPC which can be used by EKS"
  default     = [""]
  type        = list(string)
}

variable "kms_key_enabled" {
  description = "Controls if a KMS key for cluster encryption should be created"
  type        = bool
  default     = false
}

variable "eks_cluster_security_group_additional_rules" {
  description = "List of additional security group rules to add to the cluster security group created."
  type        = any
  default     = {}
}

variable "aws_auth_configmap_enabled" {
  description = "Determines whether to manage the aws-auth configmap"
  default     = false
  type        = bool
}

variable "aws_auth_users" {
  description = "List of user maps to add to the aws-auth configmap"
  type        = any
  default     = []
}

variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "ipv6_enabled" {
  description = "Enable cluster IP family as Ipv6"
  type        = bool
  default     = false
}
variable "eks_default_addon_enabled" {
  description = "Enable deafult addons(vpc-cni, ebs-csi) at the time of cluster creation"
  type        = bool
  default     = false
}

variable "eks_nodes_keypair_name" {
  description = "The public key to be used for EKS cluster worker nodes."
  type        = string
  default     = ""
}

variable "eks_cluster_name" {
  description = "Name of EKS cluster"
  type        = string
  default     = ""
}

variable "eks_ng_instance_types" {
  description = "The instance types to be used for the EKS node group (e.g., t2.medium)."
  type        = list(any)
  default     = ["t3a.medium"]
}

variable "eks_ng_capacity_type" {
  description = "The capacity type for the EKS node group (ON_DEMAND or SPOT)."
  type        = string
  default     = "ON_DEMAND"
}

variable "image_high_threshold_percent" {
  description = "The percentage of disk usage at which garbage collection should be triggered."
  type        = number
  default     = 60
}

variable "image_low_threshold_percent" {
  description = "The percentage of disk usage at which garbage collection took place."
  type        = number
  default     = 40
}

variable "eventRecordQPS" {
  description = "The maximum number of events created per second."
  type        = number
  default     = 5
}


variable "associate_public_ip_address" {
  description = "Set to true to enable network interface for launch template."
  type        = bool
  default     = false
}

variable "eks_ng_monitoring_enabled" {
  description = "Specify whether to enable monitoring for nodes."
  type        = bool
  default     = true
}

variable "eks_ng_min_size" {
  description = "The minimum number of nodes for the node group."
  type        = string
  default     = "1"
}

variable "eks_ng_max_size" {
  description = "The maximum number of nodes that can be added to the node group."
  type        = string
  default     = "3"
}

variable "eks_ng_desired_size" {
  description = "The desired number of nodes for the node group."
  type        = string
  default     = "1"
}

variable "eks_ebs_volume_size" {
  description = "The type of EBS volume for nodes."
  type        = string
  default     = "50"
}

variable "eks_ebs_volume_type" {
  description = "Specify the type of EBS volume for nodes."
  type        = string
  default     = "gp3"
}

variable "eks_ebs_encrypted" {
  description = "Specify whether to encrypt the EBS volume for nodes."
  type        = bool
  default     = true
}

variable "vpc_subnet_ids" {
  description = "The IDs of the subnets in the VPC that can be used by EKS."
  type        = list(string)
  default     = [""]
}

variable "tags" {
  description = "Tags to be applied to the node group."
  type        = any
  default     = {}
}

variable "k8s_labels" {
  description = "Labels to be applied to the Kubernetes node groups."
  type        = map(any)
  default     = {}
}

#node group role
variable "worker_iam_role_arn" {
  description = "The ARN of the worker role for EKS."
  type        = string
  default     = ""
}

variable "worker_iam_role_name" {
  description = "The name of the EKS Worker IAM role."
  type        = string
  default     = ""
}

variable "update_default_version" {
  description = "Set to true if update the default version of launch template for eks template."
  type        = bool
  default     = true
}

variable "eks_volume_delete_on_termination" {
  description = "Set to true if delete the volumes when eks cluster is terminated."
  type        = bool
  default     = true
}

variable "eks_network_interfaces_delete_on_termination" {
  description = "Set to true if delete the network interfaces when eks cluster is terminated."
  type        = bool
  default     = true
=======
variable "managed_ng_pod_capacity" {
  description = "Maximum number of pods you want to schedule on one node. This value should not exceed 110."
  default     = 70
  type        = number
}
variable "cluster_iam_role_dns_suffix" {
  description = "Base DNS domain name for the current partition (e.g., amazonaws.com in AWS Commercial, amazonaws.com.cn in AWS China)"
  type        = string
  default     = "amazonaws.com"
}
