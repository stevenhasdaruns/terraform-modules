terraform {
  required_version = ">= 0.12.27"
  required_providers {
    helm = {
      source  = "helm"
      version = "~> 2.0.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    kubernetes = {
      source  = "kubernetes"
      version = ">= 1.11"
    }
  }
}