# Proxmox Connection Variables
variable "proxmox_api_url" {
  description = "Proxmox API URL (e.g., https://proxmox.example.com:8006/api2/json)"
  type        = string
}

variable "proxmox_user" {
  description = "Proxmox API user (e.g., root@pam or ansible@pve)"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox API password"
  type        = string
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  description = "Skip TLS verification (set to true for self-signed certificates)"
  type        = bool
  default     = true
}

variable "proxmox_node" {
  description = "Proxmox node name where VMs will be created"
  type        = string
}

# VM Template or Clone Configuration
variable "use_clone" {
  description = "Whether to clone from template (true) or create from scratch (false)"
  type        = bool
  default     = false
}

variable "clone_template_control_plane" {
  description = "Name of the template to clone for control plane nodes"
  type        = string
  default     = "ControlPlane"
}

variable "clone_template_worker" {
  description = "Name of the template to clone for worker nodes"
  type        = string
  default     = "WorkerNode"
}

# Talos ISO Configuration (for non-clone deployments)
variable "talos_iso_storage" {
  description = "Storage location for Talos ISO"
  type        = string
  default     = "local"
}

variable "talos_iso_file" {
  description = "Talos ISO file name"
  type        = string
  default     = "talos-amd64.iso"
}

# Storage Configuration
variable "storage_pool" {
  description = "Storage pool for VM disks"
  type        = string
  default     = "local-lvm"
}

# Network Configuration
variable "network_bridge" {
  description = "Network bridge for VMs"
  type        = string
  default     = "vmbr0"
}

variable "network_model" {
  description = "Network interface model"
  type        = string
  default     = "virtio"
}

variable "network_vlan" {
  description = "VLAN tag (set to -1 for no VLAN)"
  type        = number
  default     = -1
}

# Control Plane Configuration
variable "control_plane_count" {
  description = "Number of control plane nodes"
  type        = number
  default     = 1
}

variable "control_plane_vmid_start" {
  description = "Starting VMID for control plane nodes"
  type        = number
  default     = 800
}

variable "control_plane_name_prefix" {
  description = "Name prefix for control plane nodes"
  type        = string
  default     = "master"
}

variable "control_plane_cores" {
  description = "CPU cores for control plane nodes"
  type        = number
  default     = 4
}

variable "control_plane_sockets" {
  description = "CPU sockets for control plane nodes"
  type        = number
  default     = 1
}

variable "control_plane_memory" {
  description = "Memory (MB) for control plane nodes"
  type        = number
  default     = 8192
}

variable "control_plane_disk_size" {
  description = "Disk size for control plane nodes (e.g., '100G')"
  type        = string
  default     = "100G"
}

variable "control_plane_ip_start" {
  description = "Starting IP address for control plane nodes (e.g., 10.0.0.51)"
  type        = string
  default     = "10.0.0.51"
}

variable "control_plane_mac_start" {
  description = "Starting MAC address for control plane nodes (e.g., BC:24:11:11:11:01)"
  type        = string
  default     = "BC:24:11:11:11:01"
}

# Worker Node Configuration
variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "worker_vmid_start" {
  description = "Starting VMID for worker nodes"
  type        = number
  default     = 810
}

variable "worker_name_prefix" {
  description = "Name prefix for worker nodes"
  type        = string
  default     = "agent"
}

variable "worker_cores" {
  description = "CPU cores for worker nodes"
  type        = number
  default     = 4
}

variable "worker_sockets" {
  description = "CPU sockets for worker nodes"
  type        = number
  default     = 1
}

variable "worker_memory" {
  description = "Memory (MB) for worker nodes"
  type        = number
  default     = 16384
}

variable "worker_disk_size" {
  description = "Disk size for worker nodes (e.g., '200G')"
  type        = string
  default     = "200G"
}

variable "worker_ip_start" {
  description = "Starting IP address for worker nodes (e.g., 10.0.0.52)"
  type        = string
  default     = "10.0.0.52"
}

variable "worker_mac_start" {
  description = "Starting MAC address for worker nodes (e.g., BC:24:11:11:11:02)"
  type        = string
  default     = "BC:24:11:11:11:02"
}

# Network Settings
variable "gateway" {
  description = "Network gateway"
  type        = string
  default     = "10.0.0.1"
}

variable "nameserver" {
  description = "DNS nameserver"
  type        = string
  default     = "8.8.8.8"
}

variable "cidr" {
  description = "Network CIDR (e.g., /24)"
  type        = string
  default     = "/24"
}

# General VM Settings
variable "onboot" {
  description = "Start VMs on boot"
  type        = bool
  default     = true
}

variable "agent_enabled" {
  description = "Enable QEMU guest agent"
  type        = bool
  default     = true
}

variable "vm_description" {
  description = "Description for VMs"
  type        = string
  default     = "Talos Kubernetes Node - Managed by Terraform"
}
