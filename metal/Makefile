.POSIX:

TERRAFORM ?= terraform
ANSIBLE ?= ansible-playbook

TF_DIR = terraform
ANS_DIR = ansible

export KUBECONFIG = $(CURDIR)/$(ANS_DIR)/kubeconfig

default: all

all: terraform_apply install_k3s

init: 
	cd $(TF_DIR) && $(TERRAFORM) init

plan: $(TF_DIR)/.terraform.lock.hcl $(TF_DIR)/terraform.tfvars
	cd $(TF_DIR) && $(TERRAFORM) plan

terraform_apply: $(TF_DIR)/.terraform.lock.hcl $(TF_DIR)/terraform.tfvars
	cd $(TF_DIR) && $(TERRAFORM) apply -auto-approve

terraform_destroy: $(TF_DIR)/.terraform.lock.hcl
	cd $(TF_DIR) && $(TERRAFORM) destroy -auto-approve

# Match the original interface: `make boot` and `make cluster`.
boot: terraform_apply
cluster: install_k3s

install_k3s:
	$(ANSIBLE) -i $(ANS_DIR)/inventory.ini $(ANS_DIR)/playbook.yaml -v

install_cilium:
	$(ANSIBLE) -i $(ANS_DIR)/inventory.ini $(ANS_DIR)/playbook.yaml --tags cilium -v

syntax_check:
	$(ANSIBLE) -i $(ANS_DIR)/inventory.ini $(ANS_DIR)/playbook.yaml --syntax-check

destroy: terraform_destroy
	rm -f $(ANS_DIR)/inventory.ini $(ANS_DIR)/kubeconfig

console:
	cd $(TF_DIR) && $(TERRAFORM) console
