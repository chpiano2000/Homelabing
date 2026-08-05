resource "random_password" "k3s_token" {
  length  = 32
  special = false
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tftpl", {
    masters                = var.masters
    workers                = var.workers
    first_master           = local.first_master
    ansible_user           = var.ansible_user
    ssh_private_key_path   = var.ssh_private_key_path
    k3s_token              = random_password.k3s_token.result
    control_plane_endpoint = var.control_plane_endpoint
    load_balancer_ip_pool  = var.load_balancer_ip_pool
  })
  filename        = "${path.module}/../ansible/inventory.ini"
  file_permission = "0600"

  depends_on = [proxmox_virtual_environment_vm.node]
}
