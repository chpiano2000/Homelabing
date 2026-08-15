terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.2.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}
