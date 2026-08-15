variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token - needs Account:Cloudflare Tunnel:Edit, Zone:Zone:Read, Zone:DNS:Edit, User:API Tokens:Edit (to manage the per-service tokens this module creates)"
  sensitive   = true
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare account ID that owns the zone and the tunnel"
}

variable "kubeconfig_path" {
  type        = string
  description = "Path to the kubeconfig used to write Kubernetes secrets"
  default     = "../metal/ansible/kubeconfig.yaml"
}
