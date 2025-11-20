# Provision VMs with Talos OS in 1 node promox

- Download and create template first

```bash
talosctl gen config talos-proxmox-cluster https://10.0.0.51:6443 --output-dir "/home/ansible/.talos" --install-image factory.talos.dev/installer/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515:v1.11.0

talosctl apply-config --insecure --nodes 10.0.0.51 --file /home/ansible/.talos/controlplane.yaml

talosctl -n 10.0.0.51 apply-config --file /home/ansible/.talos/controlplane.yaml --mode=auto

# Update TalosCTL configs
talosctl config endpoint 10.0.0.51 --talosconfig /home/ansible/.talos/talosconfig
talosctl config node 10.0.0.51 --talosconfig /home/ansible/.talos/talosconfig
talosctl bootstrap --talosconfig /home/ansible/.talos/talosconfig

talosctl kubeconfig . --talosconfig /home/ansible/.talos/talosconfig

# Add Worker Node
talosctl apply-config --insecure --nodes 10.0.0.52 --file /home/ansible/.talos/worker.yaml
talosctl apply-config --insecure --nodes 10.0.0.53 --file /home/ansible/.talos/worker.yaml
```

