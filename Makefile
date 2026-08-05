.POSIX:
.PHONY: default all metal external system cert-manager argocd destroy

KUBECONFIG ?= $(CURDIR)/metal/ansible/kubeconfig.yaml
export KUBECONFIG

default: all

all: metal external system

metal:
	make -C metal

system:
	make -C system 

external:
	make -C external

destroy:
	make -C metal destroy
