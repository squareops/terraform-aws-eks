terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.23"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.13"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6"
    }
  }
}
