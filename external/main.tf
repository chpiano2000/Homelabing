resource "kubernetes_namespace_v1" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_namespace_v1" "external_dns" {
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_namespace_v1" "cloudflared" {
  metadata {
    name = "cloudflared"
  }
}

module "cloudflare" {
  source = "./modules/cloudflare"

  cloudflare_account_id = var.cloudflare_account_id

  depends_on = [
    kubernetes_namespace_v1.cert_manager,
    kubernetes_namespace_v1.external_dns,
    kubernetes_namespace_v1.cloudflared,
  ]
}
