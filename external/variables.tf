variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token with Zone:Read + DNS:Edit scoped to your zone (used by cert-manager DNS01 solver)"
  sensitive   = true
}

variable "kubeconfig_path" {
  type        = string
  description = "Path to the kubeconfig used to write the cert-manager Secret"
  default     = "../metal/ansible/kubeconfig.yaml"
}
