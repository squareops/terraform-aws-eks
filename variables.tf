variable "environment" {
  description = "Environment identifier for the EKS cluster"
  default     = ""
  type        = string
}

variable "name" {
  description = "Specify the name of the EKS cluster"
  default     = ""
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes <major>.<minor> version to use for the EKS cluster"
  default     = ""
  type        = string
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether the Amazon EKS public API server endpoint is enabled or not"
  default     = true
  type        = bool
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  default     = [""]
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster and its nodes will be provisioned"
  default     = ""
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key to Encrypt EKS resources."
  default     = ""
  type        = string
}

variable "cluster_log_types" {
  description = "A list of the desired control plane logs to enable for EKS cluster. Valid values: api,audit,authenticator,controllerManager,scheduler"
  default     = [""]
  type        = list(string)
}

variable "cluster_log_retention_in_days" {
  description = "Retention period for EKS cluster logs"
  default     = 90
  type        = number
}
