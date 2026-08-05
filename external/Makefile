.POSIX:

default: apply

terraform.tfvars:
	cp terraform.tfvars.example $@
	$${EDITOR:-vi} $@

.terraform.lock.hcl: versions.tf terraform.tfvars
	terraform init
	touch $@

plan: .terraform.lock.hcl
	terraform plan

apply: .terraform.lock.hcl
	terraform apply -auto-approve

destroy:
	terraform destroy
