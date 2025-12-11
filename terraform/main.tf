# Control Plane Nodes
resource "proxmox_vm_qemu" "control_plane" {
  count = var.control_plane_count

  # VM Identification
  name        = var.control_plane_count > 1 ? "${var.control_plane_name_prefix}${count.index + 1}" : var.control_plane_name_prefix
  vmid        = var.control_plane_vmid_start + count.index
  target_node = var.proxmox_node
  desc        = var.vm_description

  # Clone or Create from scratch
  clone   = var.use_clone ? var.clone_template_control_plane : null
  full_clone = var.use_clone ? true : null

  # Boot Configuration (for non-clone deployments)
  iso = var.use_clone ? null : "${var.talos_iso_storage}:iso/${var.talos_iso_file}"

  # Hardware Configuration
  cores   = var.control_plane_cores
  sockets = var.control_plane_sockets
  memory  = var.control_plane_memory

  # BIOS and CPU Settings
  bios    = "ovmf"
  cpu     = "host"
  scsihw  = "virtio-scsi-pci"

  # Boot Order
  boot    = "order=scsi0"

  # VM Options
  onboot  = var.onboot
  agent   = var.agent_enabled ? 1 : 0

  # Disk Configuration
  dynamic "disks" {
    for_each = var.use_clone ? [] : [1]
    content {
      scsi {
        scsi0 {
          disk {
            size    = var.control_plane_disk_size
            storage = var.storage_pool
            iothread = true
          }
        }
      }
    }
  }

  # For cloned VMs, resize the disk if needed
  disk {
    slot    = 0
    size    = var.control_plane_disk_size
    type    = "scsi"
    storage = var.storage_pool
    iothread = 1
  }

  # Network Configuration
  network {
    model   = var.network_model
    bridge  = var.network_bridge
    macaddr = var.control_plane_count == 1 ? var.control_plane_mac_start : format(
      "BC:24:11:11:11:%02X",
      parseint(split(":", var.control_plane_mac_start)[5], 16) + count.index
    )
    tag     = var.network_vlan != -1 ? var.network_vlan : null
  }

  # IP Configuration (using cloud-init if available, or will be configured by Talos)
  ipconfig0 = "ip=${cidrhost("${var.control_plane_ip_start}${var.cidr}", count.index)},gw=${var.gateway}"
  nameserver = var.nameserver

  # VM Lifecycle
  lifecycle {
    ignore_changes = [
      network,
      disk,
    ]
  }
}

# Worker Nodes
resource "proxmox_vm_qemu" "worker" {
  count = var.worker_count

  # VM Identification
  name        = "${var.worker_name_prefix}${count.index + 1}"
  vmid        = var.worker_vmid_start + count.index
  target_node = var.proxmox_node
  desc        = var.vm_description

  # Clone or Create from scratch
  clone   = var.use_clone ? var.clone_template_worker : null
  full_clone = var.use_clone ? true : null

  # Boot Configuration (for non-clone deployments)
  iso = var.use_clone ? null : "${var.talos_iso_storage}:iso/${var.talos_iso_file}"

  # Hardware Configuration
  cores   = var.worker_cores
  sockets = var.worker_sockets
  memory  = var.worker_memory

  # BIOS and CPU Settings
  bios    = "ovmf"
  cpu     = "host"
  scsihw  = "virtio-scsi-pci"

  # Boot Order
  boot    = "order=scsi0"

  # VM Options
  onboot  = var.onboot
  agent   = var.agent_enabled ? 1 : 0

  # Disk Configuration
  dynamic "disks" {
    for_each = var.use_clone ? [] : [1]
    content {
      scsi {
        scsi0 {
          disk {
            size    = var.worker_disk_size
            storage = var.storage_pool
            iothread = true
          }
        }
      }
    }
  }

  # For cloned VMs, resize the disk if needed
  disk {
    slot    = 0
    size    = var.worker_disk_size
    type    = "scsi"
    storage = var.storage_pool
    iothread = 1
  }

  # Network Configuration
  network {
    model   = var.network_model
    bridge  = var.network_bridge
    macaddr = format(
      "BC:24:11:11:11:%02X",
      parseint(split(":", var.worker_mac_start)[5], 16) + count.index
    )
    tag     = var.network_vlan != -1 ? var.network_vlan : null
  }

  # IP Configuration (using cloud-init if available, or will be configured by Talos)
  ipconfig0 = "ip=${cidrhost("${var.worker_ip_start}${var.cidr}", count.index)},gw=${var.gateway}"
  nameserver = var.nameserver

  # VM Lifecycle
  lifecycle {
    ignore_changes = [
      network,
      disk,
    ]
  }
}
