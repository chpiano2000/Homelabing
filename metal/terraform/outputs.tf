output "inventory_path" {
  description = "Rendered Ansible inventory. Passed to ansible-playbook by the top-level Makefile."
  value       = local_file.ansible_inventory.filename
}

output "kubeconfig_path" {
  description = "Where the Ansible post-install play drops the fetched kubeconfig."
  value       = "${path.module}/../ansible/kubeconfig"
}

output "control_plane_endpoint" {
  value = var.control_plane_endpoint
}

output "masters" {
  value = { for k, v in var.masters : k => v.ip }
}

output "workers" {
  value = { for k, v in var.workers : k => v.ip }
}

output "k3s_token" {
  value     = random_password.k3s_token.result
  sensitive = true
}
