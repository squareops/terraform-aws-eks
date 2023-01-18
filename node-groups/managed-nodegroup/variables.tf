variable "eks_cluster_id" {
  type        = string
  default     = "stgg-msa-ref"
  description = "Cluster ID for EKS"
}

variable "environment" {
  default     = null
  type        = string
  description = "Enviornment for nodes/nodegroups."
}

variable "name" {
  description = "Specify the name of the EKS Nodegroup"
  default     = "EKS-nodegroup"
  type        = string
}

variable "instance_types" {
  type        = list(any)
  default     = ["t3a.medium"]
  description = "Specify the instance type eg. t2.medium etc."
}

variable "capacity_type" {
  default     = "ON_DEMAND"
  type        = string
  description = "Capacity type ON_DEMAND/SPOT"
}

variable "image_high_threshold_percent" {
  default     = 60
  type        = number
  description = "Defines the percent of disk usage on garbage collection should trigger."
}

variable "image_low_threshold_percent" {
  default     = 40
  type        = number
  description = "Define the percentage of disk usage till the garbage collection took place."
}

variable "eventRecordQPS" {
  default     = 5
  type        = number
  description = "Specify the maximum no. of events creation per second."
}

variable "eks_nodes_keypair" {
  description = "The public key for EkS cluster"
  default     = ""
  type        = string
}

variable "kms_key_id" {
  type        = string
  default     = ""
  description = "KMS key ID for Encrypting Node groups."
}

variable "kms_policy_arn" {
  type        = string
  default     = ""
  description = "KMS key ARN for Encrypting Node groups."
}
variable "associate_public_ip_address" {
  description = "Set true if you want to enable network interface for launch template"
  default     = false
  type        = bool
}

variable "enable_monitoring" {
  type        = bool
  default     = true
  description = "Specify to enable monitoring for nodes."
}

variable "min_size" {
  type        = string
  default     = "1"
  description = "Specify minimum no. of nodes for nodegroup"
}

variable "max_size" {
  type        = string
  default     = "3"
  description = "Specify maximum no. of nodes can be added in nodegroup."
}

variable "desired_size" {
  type        = string
  default     = "3"
  description = "Specify the desired no. for Nodegroups"
}

variable "ebs_volume_size" {
  type        = string
  default     = "50"
  description = "Specify the Size of the EBS volume for nodes."
}

variable "ebs_volume_type" {
  type        = string
  default     = "gp3"
  description = "Specify the type of EBS volume for nodes."
}

variable "ebs_encrypted" {
  type        = bool
  default     = true
  description = "Specify weather to encrypt EBS volume for nodes or not."
}

variable "subnet_ids" {
  description = " subnets of the VPC which can be used by EKS"
  default     = [""]
  type        = list(string)
}

variable "tags" {
  type        = any
  default     = {}
  description = "tags for the nodegroup"
}

variable "k8s_labels" {
  type        = map(any)
  default     = {}
  description = "K8s label for the nodegroups"
}

variable "kubelet_extra_args" {
  description = "Additional arguments passed to the kubelet"
  type        = string
  default     = "--max-pods=58" # we are setting the hard limit of maximum pods per node i.e 256
}

#node group role
variable "worker_iam_role_arn" {
  type        = string
  default     = ""
  description = "ARN for worker role of EKS"
}

variable "worker_iam_role_name" {
  description = "The name of the EKS Worker IAM role"
  type        = string
  default     = ""
}
