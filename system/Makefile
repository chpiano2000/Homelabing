.POSIX:

export KUBECONFIG = $(shell pwd)/../metal/ansible/kubeconfig.yaml

.PHONY: bootstrap
bootstrap:
	ansible-playbook \
		bootstrap.yml

