variable "eks_cluster_name" {
  description = "Cluster ID for EKS"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Enviornment for nodes/nodegroups."
  type        = string
  default     = null
}

variable "name" {
  description = "Specify the name of the EKS Nodegroup"
  type        = string
  default     = ""
}

variable "instance_types" {
  description = "Specify the instance type eg. t2.medium etc."
  type        = list(any)
  default     = ["t3a.medium"]
}

variable "capacity_type" {
  description = "Capacity type ON_DEMAND/SPOT"
  type        = string
  default     = "ON_DEMAND"
}

variable "image_high_threshold_percent" {
  description = "Defines the percent of disk usage on garbage collection should trigger."
  type        = number
  default     = 60
}

variable "image_low_threshold_percent" {
  description = "Define the percentage of disk usage till the garbage collection took place."
  type        = number
  default     = 40
}

variable "eventRecordQPS" {
  description = "Specify the maximum no. of events creation per second."
  type        = number
  default     = 5
}

variable "eks_nodes_keypair" {
  description = "The public key for EkS cluster"
  type        = string
  default     = ""
}

variable "kms_key_arn" {
  description = "KMS key ID for Encrypting Node groups."
  type        = string
  default     = ""
}

variable "kms_policy_arn" {
  description = "KMS key ARN for Encrypting Node groups."
  type        = string
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Set true if you want to enable network interface for launch template"
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "Specify to enable monitoring for nodes."
  type        = bool
  default     = true
}

variable "min_size" {
  description = "Specify minimum no. of nodes for nodegroup"
  type        = string
  default     = "1"
}

variable "max_size" {
  description = "Specify maximum no. of nodes can be added in nodegroup."
  type        = string
  default     = "3"
}

variable "desired_size" {
  description = "Specify the desired no. for Nodegroups"
  type        = string
  default     = "3"
}

variable "ebs_volume_size" {
  description = "Specify the Size of the EBS volume for nodes."
  type        = string
  default     = "50"
}

variable "ebs_volume_type" {
  description = "Specify the type of EBS volume for nodes."
  type        = string
  default     = "gp3"
}

variable "ebs_encrypted" {
  description = "Specify weather to encrypt EBS volume for nodes or not."
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = " subnets of the VPC which can be used by EKS"
  type        = list(string)
  default     = [""]
}

variable "tags" {
  description = "tags for the nodegroup"
  type        = any
  default     = {}
}

variable "k8s_labels" {
  description = "K8s label for the nodegroups"
  type        = map(any)
  default     = {}
}

#node group role
variable "worker_iam_role_arn" {
  description = "ARN for worker role of EKS"
  type        = string
  default     = ""
}

variable "worker_iam_role_name" {
  description = "The name of the EKS Worker IAM role"
  type        = string
  default     = ""
}
