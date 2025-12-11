# Control Plane Outputs
output "control_plane_vms" {
  description = "Control plane VM details"
  value = {
    for idx, vm in proxmox_vm_qemu.control_plane : vm.name => {
      vmid       = vm.vmid
      name       = vm.name
      ip_address = vm.default_ipv4_address
      mac_address = vm.network[0].macaddr
      node       = vm.target_node
    }
  }
}

output "control_plane_ips" {
  description = "Control plane IP addresses"
  value       = [for vm in proxmox_vm_qemu.control_plane : vm.default_ipv4_address]
}

# Worker Outputs
output "worker_vms" {
  description = "Worker VM details"
  value = {
    for idx, vm in proxmox_vm_qemu.worker : vm.name => {
      vmid       = vm.vmid
      name       = vm.name
      ip_address = vm.default_ipv4_address
      mac_address = vm.network[0].macaddr
      node       = vm.target_node
    }
  }
}

output "worker_ips" {
  description = "Worker node IP addresses"
  value       = [for vm in proxmox_vm_qemu.worker : vm.default_ipv4_address]
}

# All VMs
output "all_vms" {
  description = "All VM details"
  value = merge(
    { for vm in proxmox_vm_qemu.control_plane : vm.name => {
      vmid       = vm.vmid
      name       = vm.name
      type       = "control-plane"
      ip_address = vm.default_ipv4_address
      mac_address = vm.network[0].macaddr
      node       = vm.target_node
    }},
    { for vm in proxmox_vm_qemu.worker : vm.name => {
      vmid       = vm.vmid
      name       = vm.name
      type       = "worker"
      ip_address = vm.default_ipv4_address
      mac_address = vm.network[0].macaddr
      node       = vm.target_node
    }}
  )
}

# Ansible Inventory Format
output "ansible_inventory" {
  description = "Ansible inventory format for easy integration"
  value = <<-EOT
    [all:vars]
    load_balancer_ip_pool = '[10.0.0.100/27]'

    [masters]
    %{for vm in proxmox_vm_qemu.control_plane~}
    ${vm.name} ansible_host=${vm.default_ipv4_address} mac_address=${vm.network[0].macaddr}
    %{endfor~}

    [agents]
    %{for vm in proxmox_vm_qemu.worker~}
    ${vm.name} ansible_host=${vm.default_ipv4_address} mac_address=${vm.network[0].macaddr}
    %{endfor~}
  EOT
}
