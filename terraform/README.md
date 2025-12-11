# Proxmox VM Provisioning with Terraform

This Terraform configuration automates the provisioning of Proxmox VMs for a Talos Kubernetes cluster, replacing the previous Ansible-based approach.

## Features

- **Automated VM Provisioning**: Creates control plane and worker node VMs
- **Flexible Configuration**: Clone from templates or create from scratch
- **Network Management**: Configurable MAC addresses, IPs, and network settings
- **Resource Allocation**: Customizable CPU, memory, and disk specifications
- **Ansible Integration**: Outputs Ansible inventory format for easy integration

## Prerequisites

1. **Terraform** >= 1.0
2. **Proxmox VE** server with API access
3. **API User** with appropriate permissions
4. **(Optional)** Pre-created templates if using clone mode:
   - `ControlPlane` template for control plane nodes
   - `WorkerNode` template for worker nodes
5. **(Optional)** Talos ISO uploaded to Proxmox if creating from scratch

## Quick Start

### 1. Configuration

Copy the example variables file and customize it:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your Proxmox settings:

```hcl
proxmox_api_url  = "https://your-proxmox-host:8006/api2/json"
proxmox_user     = "root@pam"
proxmox_password = "your-password"
proxmox_node     = "pve"
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Preview Changes

```bash
terraform plan
```

### 4. Deploy Infrastructure

```bash
terraform apply
```

### 5. View Outputs

After deployment, view the created VMs:

```bash
# All VM details
terraform output all_vms

# Generate Ansible inventory
terraform output -raw ansible_inventory > ../inventories/home/hosts_terraform.ini
```

## Configuration Options

### Clone vs. Create from Scratch

**Clone Mode (Default):**
- Faster deployment
- Requires pre-existing templates
- Set `use_clone = true`

```hcl
use_clone                    = true
clone_template_control_plane = "ControlPlane"
clone_template_worker        = "WorkerNode"
```

**Create from Scratch:**
- More control over VM specs
- Requires Talos ISO uploaded to Proxmox
- Set `use_clone = false`

```hcl
use_clone         = false
talos_iso_storage = "local"
talos_iso_file    = "talos-amd64.iso"
```

### Network Configuration

```hcl
network_bridge = "vmbr0"         # Network bridge
network_model  = "virtio"        # NIC model
network_vlan   = -1              # VLAN tag (-1 for none)
gateway        = "10.0.0.1"      # Default gateway
nameserver     = "8.8.8.8"       # DNS server
cidr           = "/24"           # Network CIDR
```

### Control Plane Nodes

```hcl
control_plane_count      = 1                    # Number of control plane nodes
control_plane_cores      = 4                    # CPU cores
control_plane_memory     = 8192                 # Memory in MB
control_plane_disk_size  = "100G"               # Disk size
control_plane_ip_start   = "10.0.0.51"          # Starting IP
control_plane_mac_start  = "BC:24:11:11:11:01" # Starting MAC
```

### Worker Nodes

```hcl
worker_count      = 2                    # Number of worker nodes
worker_cores      = 4                    # CPU cores
worker_memory     = 16384                # Memory in MB
worker_disk_size  = "200G"               # Disk size
worker_ip_start   = "10.0.0.52"          # Starting IP
worker_mac_start  = "BC:24:11:11:11:02" # Starting MAC
```

## Default VM Specifications

Based on the current Ansible setup, the defaults match:

**Control Plane (master):**
- 1 node
- 4 CPU cores
- 8GB RAM
- 100GB disk
- IP: 10.0.0.51
- MAC: BC:24:11:11:11:01

**Workers (agent1, agent2):**
- 2 nodes
- 4 CPU cores per node
- 16GB RAM per node
- 200GB disk per node
- IPs: 10.0.0.52, 10.0.0.53
- MACs: BC:24:11:11:11:02, BC:24:11:11:11:03

## Integration with Existing Workflow

### Continue Using Ansible for Talos Bootstrap

After Terraform provisions the VMs, use the existing Ansible playbooks for Talos:

```bash
# Provision VMs with Terraform
cd terraform
terraform apply

# Bootstrap Talos with Ansible
cd ..
make provision
```

### Generate Ansible Inventory

Terraform can generate an Ansible-compatible inventory:

```bash
terraform output -raw ansible_inventory > ../inventories/home/hosts_terraform.ini
```

Then update your Ansible commands to use this inventory:

```bash
ansible-playbook -i inventories/home/hosts_terraform.ini playbooks/k8s_provision.yaml
```

## Scaling

### Add More Control Plane Nodes

```hcl
control_plane_count = 3  # Create HA control plane
```

### Add More Worker Nodes

```hcl
worker_count = 5  # Scale to 5 workers
```

IP addresses and MAC addresses will automatically increment.

## Outputs

The configuration provides several useful outputs:

- `control_plane_vms` - Control plane VM details
- `worker_vms` - Worker VM details
- `all_vms` - All VM details combined
- `ansible_inventory` - Ready-to-use Ansible inventory format

## Destroying Infrastructure

To remove all VMs:

```bash
terraform destroy
```

## Migration from Ansible

### Differences from Ansible Approach

| Aspect | Ansible | Terraform |
|--------|---------|-----------|
| State Management | Stateless | Stateful (terraform.tfstate) |
| VM Specs | Template-based | Configurable in code |
| Idempotency | Role-based | Resource-based |
| Dependencies | Sequential tasks | Declarative resources |

### Migration Steps

1. **Backup Current Setup**: Document existing VM configurations
2. **Configure Terraform**: Update `terraform.tfvars` with your settings
3. **Test Deployment**: Deploy to a test environment first
4. **Validate**: Ensure VMs are created with correct specs
5. **Bootstrap Talos**: Use existing Ansible playbooks for Talos setup
6. **Decommission Old VMs**: Remove manually created or Ansible-managed VMs

## Troubleshooting

### Authentication Issues

```bash
# Test Proxmox API access
curl -k -d "username=root@pam&password=yourpassword" \
  https://your-proxmox:8006/api2/json/access/ticket
```

### Template Not Found

Ensure templates exist:
```bash
# List templates on Proxmox
qm list | grep template
```

### Network Issues

Verify network bridge:
```bash
# On Proxmox host
ip link show vmbr0
```

### State Issues

If state becomes corrupted:
```bash
# Remove state (CAUTION: Use only if needed)
rm terraform.tfstate*

# Re-import existing VMs
terraform import proxmox_vm_qemu.control_plane[0] <node>/<vmid>
```

## Security Best Practices

1. **Never commit `terraform.tfvars`** - It contains sensitive credentials
2. **Use API tokens** instead of passwords when possible
3. **Enable TLS verification** in production (`proxmox_tls_insecure = false`)
4. **Store state remotely** for team environments (S3, Terraform Cloud, etc.)
5. **Use environment variables** for sensitive values:

```bash
export TF_VAR_proxmox_password="your-password"
terraform apply
```

## Advanced Configuration

### Remote State Backend

For team collaboration, configure remote state:

```hcl
terraform {
  backend "s3" {
    bucket = "your-terraform-state"
    key    = "proxmox/terraform.tfstate"
    region = "us-east-1"
  }
}
```

### Using Proxmox API Token

Instead of username/password:

```hcl
proxmox_api_token_id     = "root@pam!your-token-id"
proxmox_api_token_secret = "your-token-secret"
```

## Files

```
terraform/
├── provider.tf              # Terraform and provider configuration
├── variables.tf             # Variable definitions
├── main.tf                  # VM resource definitions
├── outputs.tf               # Output definitions
├── terraform.tfvars.example # Example configuration
├── terraform.tfvars         # Your actual configuration (gitignored)
├── .gitignore              # Ignore sensitive files
└── README.md               # This file
```

## Resources

- [Telmate Proxmox Provider Documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Proxmox VE API Documentation](https://pve.proxmox.com/pve-docs/api-viewer/)
- [Talos Linux Documentation](https://www.talos.dev/)
