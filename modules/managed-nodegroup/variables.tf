variable "eks_cluster_name" {
  description = "Name of EKS cluster"
  type        = string
  default     = ""
}

variable "environment" {
  description = "The environment for the nodes or node groups."
  type        = string
  default     = null
}

variable "name" {
  description = "Specify the name of the EKS Nodegroup"
  type        = string
  default     = ""
}

variable "instance_types" {
  description = "The instance types to be used for the EKS node group (e.g., t2.medium)."
  type        = list(any)
  default     = ["t3a.medium"]
}

variable "capacity_type" {
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

variable "eks_nodes_keypair_name" {
  description = "The public key to be used for EKS cluster worker nodes."
  type        = string
  default     = ""
}

variable "kms_key_arn" {
  description = "The KMS key ID used for encrypting node groups."
  type        = string
  default     = ""
}

variable "kms_policy_arn" {
  description = "The KMS policy ARN used for encrypting Kubernetes PVC."
  type        = string
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Set to true to enable network interface for launch template."
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "Specify whether to enable monitoring for nodes."
  type        = bool
  default     = true
}

variable "min_size" {
  description = "The minimum number of nodes for the node group."
  type        = string
  default     = "1"
}

variable "max_size" {
  description = "The maximum number of nodes that can be added to the node group."
  type        = string
  default     = "3"
}

variable "desired_size" {
  description = "The desired number of nodes for the node group."
  type        = string
  default     = "3"
}

variable "ebs_volume_size" {
  description = "The type of EBS volume for nodes."
  type        = string
  default     = "50"
}

variable "ebs_volume_type" {
  description = "Specify the type of EBS volume for nodes."
  type        = string
  default     = "gp3"
}

variable "ebs_encrypted" {
  description = "Specify whether to encrypt the EBS volume for nodes."
  type        = bool
  default     = true
}

variable "subnet_ids" {
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
