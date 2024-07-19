variable "additional_aws_tags" {
  description = "Additional tags to be applied to AWS resources"
  type        = map(string)
  default     = {}
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

variable "cluster_version" {
  description = "Specifies the Kubernetes version (major.minor) to use for the EKS cluster."
  default     = ""
  type        = string
}

variable "irsa_enabled" {
  description = "Set to true to associate an AWS IAM role with a Kubernetes service account. "
  default     = true
  type        = bool
}

variable "cluster_endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled or not."
  default     = true
  type        = bool
}

variable "cluster_endpoint_private_access" {
  description = "Whether the Amazon EKS private API server endpoint is enabled or not."
  default     = true
  type        = bool
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDR blocks that can access the Amazon EKS public API server endpoint."
  default     = [""]
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be deployed."
  default     = ""
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used to encrypt EKS resources."
  default     = ""
  type        = string
}

variable "cluster_log_types" {
  description = "A list of desired control plane logs to enable for the EKS cluster. Valid values include: api, audit, authenticator, controllerManager, scheduler."
  default     = []
  type        = list(string)
}

variable "cluster_log_retention_in_days" {
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

variable "cluster_security_group_additional_rules" {
  description = "List of additional security group rules to add to the cluster security group created."
  type        = any
  default     = {}
}

variable "ipv6_enabled" {
  description = "Enable cluster IP family as Ipv6"
  type        = bool
  default     = false
}

variable "default_addon_enabled" {
  description = "Enable deafult addons(vpc-cni, ebs-csi) at the time of cluster creation"
  type        = bool
  default     = false
}

variable "nodes_keypair_name" {
  description = "The public key to be used for EKS cluster worker nodes."
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "Name of EKS cluster"
  type        = string
  default     = ""
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


variable "authentication_mode" {
  description = "The authentication mode for the cluster. Valid values are `CONFIG_MAP`, `API` or `API_AND_CONFIG_MAP`"
  type        = string
  default     = "API_AND_CONFIG_MAP"
}

# Access Entry

variable "access_entry_enabled" {
  description = "Whether to enable access entry or not for eks cluster."
  type        = bool
  default     = true
}

variable "access_entries" {
  description = "Map of access entries to add to the cluster"
  type        = any
  default     = {}
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Indicates whether or not to add the cluster creator (the identity used by Terraform) as an administrator via access entry"
  type        = bool
  default     = false
}
