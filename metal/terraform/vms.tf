locals {
  nodes = merge(
    { for k, v in var.masters : k => merge(v, { role = "master" }) },
    { for k, v in var.workers : k => merge(v, { role = "worker" }) },
  )
  # Deterministic ordering so vm_id assignment is stable across plans.
  node_names = sort(keys(local.nodes))

  first_master = sort(keys(var.masters))[0]

  # One keypair: template's cloud-init trusts the .pub via user_account,
  # Ansible dials with the private half.
  ssh_public_key_path = pathexpand(
    var.ssh_public_key_path != "" ? var.ssh_public_key_path : "${var.ssh_private_key_path}.pub"
  )
  ssh_public_key = trimspace(file(local.ssh_public_key_path))
}

resource "proxmox_virtual_environment_vm" "node" {
  for_each = local.nodes

  name          = each.key
  node_name     = var.proxmox_node
  vm_id         = 200 + index(local.node_names, each.key)
  tags          = ["k3s", each.value.role]
  scsi_hardware = "virtio-scsi-single"

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
  }

  # Resize the cloned root disk. The image, interface, and datastore are
  # inherited from the template.
  disk {
    datastore_id = var.proxmox_datastore
    interface    = "scsi0"
    size         = each.value.disk
    file_format  = "qcow2"
  }

  network_device {
    bridge      = var.network_bridge
    mac_address = each.value.mac
  }

  initialization {
    datastore_id = var.proxmox_datastore
    interface    = "ide2"

    user_account {
      username = var.ansible_user
      keys     = [local.ssh_public_key]
    }

    dns {
      servers = var.dns_servers
    }

    ip_config {
      ipv4 {
        address = "${each.value.ip}/${var.network_cidr_prefix}"
        gateway = var.network_gateway
      }
    }
  }
}
