data "cloudflare_zone" "zone" {
  filter = {
    name = "daxvo.tech"
  }
}

resource "random_password" "tunnel_secret" {
  length  = 64
  special = false
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "homelab" {
  account_id    = var.cloudflare_account_id
  name          = "homelab"
  config_src    = "local"
  tunnel_secret = base64encode(random_password.tunnel_secret.result)
}

# Not proxied, not accessible. Just a record for auto-created CNAMEs by external-dns.
resource "cloudflare_dns_record" "tunnel" {
  zone_id = data.cloudflare_zone.zone.id
  type    = "CNAME"
  name    = "homelab-tunnel"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.homelab.id}.cfargotunnel.com"
  proxied = false
  ttl     = 1 # Auto
}

resource "kubernetes_secret_v1" "cloudflared_credentials" {
  metadata {
    name      = "cloudflared-credentials"
    namespace = "cloudflared"

    annotations = {
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }

  data = {
    "credentials.json" = jsonencode({
      AccountTag   = var.cloudflare_account_id
      TunnelName   = cloudflare_zero_trust_tunnel_cloudflared.homelab.name
      TunnelID     = cloudflare_zero_trust_tunnel_cloudflared.homelab.id
      TunnelSecret = base64encode(random_password.tunnel_secret.result)
    })
  }
}

locals {
  cf_permission_groups = {
    zone_read = "c8fed203ed3043cba015a93ad1616f1f"
    dns_write = "4755a26eedb94da69e1066d98aa820be"
  }
  zone_resource_key = "com.cloudflare.api.account.zone.${data.cloudflare_zone.zone.id}"
}

resource "cloudflare_api_token" "external_dns" {
  name = "homelab_external_dns"

  policies = [{
    effect = "allow"
    permission_groups = [
      { id = local.cf_permission_groups.zone_read },
      { id = local.cf_permission_groups.dns_write },
    ]
    resources = jsonencode({
      (local.zone_resource_key) = "*"
    })
  }]
}

resource "kubernetes_secret_v1" "external_dns_token" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = "external-dns"

    annotations = {
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }

  data = {
    "value" = cloudflare_api_token.external_dns.value
  }
}

resource "cloudflare_api_token" "cert_manager" {
  name = "homelab_cert_manager"

  policies = [{
    effect = "allow"
    permission_groups = [
      { id = local.cf_permission_groups.zone_read },
      { id = local.cf_permission_groups.dns_write },
    ]
    resources = jsonencode({
      (local.zone_resource_key) = "*"
    })
  }]
}

resource "kubernetes_secret_v1" "cert_manager_token" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = "cert-manager"

    annotations = {
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }

  data = {
    "api-token" = cloudflare_api_token.cert_manager.value
  }
}
