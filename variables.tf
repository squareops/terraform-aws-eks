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

variable "cluster_endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled or not."
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
  default     = [""]
  type        = list(string)
}

variable "cluster_log_retention_in_days" {
  description = "Retention period for EKS cluster logs in days. Default is set to 90 days."
  default     = 90
  type        = number
}

variable "private_subnet_ids" {
  description = "Private subnets of the VPC which can be used by EKS"
  default     = [""]
  type        = list(string)
}

variable "create_kms_key" {
  description = "Controls if a KMS key for cluster encryption should be created"
  type        = bool
  default     = false
}

variable "additional_rules" {
  description = "List of additional security group rules to add to the cluster security group created."
  type        = any
  default     = {}
}

variable "create_aws_auth_configmap" {
  description = "Determines whether to manage the aws-auth configmap"
  default     = false
  type        = bool
}

variable "aws_auth_users" {
  description = "List of user maps to add to the aws-auth configmap"
  type        = any
  default     = []
}
