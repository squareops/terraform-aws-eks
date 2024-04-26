variable "environment" {
  description = "The name of the environment (e.g., 'development', 'production')."
  type        = string
  default     = ""
}

variable "fargate_profile_name" {
  description = "The name of the Fargate profile."
  type        = string
  default     = ""
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster where fargate will be deployed."
  type        = string
  default     = ""
}

variable "iam_role_path" {
  description = "The path where IAM roles will be created."
  type        = string
  default     = "/"
}

variable "permissions_boundary" {
  description = "The ARN of the permissions boundary to attach to IAM roles."
  type        = string
  default     = null
}

variable "fargate_subnet_ids" {
  description = "A list of subnet IDs for the EKS Fargate profile."
  type        = list(string)
  default     = []
}

variable "fargate_namespace" {
  description = "The Kubernetes namespace for the Fargate profile"
  type        = string
  default     = ""
}

variable "k8s_labels" {
  description = "A map of Kubernetes labels to apply to the Fargate profile."
  type        = map(string)
}
