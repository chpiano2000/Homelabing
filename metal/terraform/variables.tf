variable "proxmox_endpoint" {
  description = "https://<pve-host>:8006/"
  type        = string
}

variable "proxmox_api_token" {
  description = "e.g. user@pam!tokenid=uuid"
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Skip TLS verification for the Proxmox API."
  type        = bool
  default     = true
}

variable "proxmox_ssh_user" {
  description = "SSH user used by bpg/proxmox to upload snippets."
  type        = string
  default     = "root"
}

variable "proxmox_node" {
  description = "Proxmox node name (`pvesh get /nodes`)."
  type        = string
}

variable "proxmox_datastore" {
  description = "Datastore for VM disks (LVM-thin, ZFS, etc.)."
  type        = string
  default     = "local-lvm"
}

variable "template_vm_id" {
  description = "VMID of the Proxmox cloud-init template to clone (e.g. 1000 for fedora-cloud-init)."
  type        = number
  default     = 1000
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "network_gateway" {
  description = "Default gateway for k3s nodes."
  type        = string
}

variable "network_cidr_prefix" {
  description = "Prefix length for node IPs (e.g. 24)."
  type        = number
  default     = 24
}

variable "dns_servers" {
  description = "DNS servers cloud-init writes into /etc/resolv.conf on each VM."
  type        = list(string)
  default     = ["1.1.1.1", "8.8.8.8"]
}

variable "ssh_private_key_path" {
  description = "Local path to the SSH private key. Passed to Ansible via the rendered inventory; used to reach the guest VMs."
  type        = string
  default     = "~/.ssh/promox-tf"
}

variable "ssh_public_key_path" {
  description = "Local path to the SSH public key. Read by Terraform and injected into cloud-init as root's only authorized_key. Defaults to <ssh_private_key_path>.pub."
  type        = string
  default     = "~/.ssh/promox-tf.pub"
}

variable "ansible_user" {
  description = "SSH user Ansible uses on the guest VMs. cloud-init injects the SSH key under this account."
  type        = string
  default     = "root"
}

variable "control_plane_endpoint" {
  description = "Address clients (kubectl, agents) use to reach the API server. Single-master: set this to the master's node IP."
  type        = string
}

variable "load_balancer_ip_pool" {
  description = "CIDR(s) Cilium hands out for LoadBalancer Services."
  type        = list(string)
}

variable "k3s_version" {
  type    = string
  default = "v1.30.4+k3s1"
}

variable "cilium_version" {
  type    = string
  default = "1.16.1"
}

# --- Node inventory -------------------------------------------------------

variable "masters" {
  description = "k3s server nodes. Map key becomes VM name/hostname."
  type = map(object({
    ip     = string
    mac    = string
    cores  = number
    memory = number # MiB
    disk   = number # GiB
  }))
}

variable "workers" {
  description = "k3s agent nodes."
  type = map(object({
    ip     = string
    mac    = string
    cores  = number
    memory = number
    disk   = number
  }))
  default = {}
}
