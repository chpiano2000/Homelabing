play:
	ansible-playbook playbooks/k8s_provision.yaml -i inventories/home/ --ask-become-pass

purge:
	ansible-playbook playbooks/purge_vms.yaml -i inventories/home/ --ask-become-pass

display:
	echo ${HOME}