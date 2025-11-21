play:
	ansible-playbook playbooks/k8s_provision.yaml -i inventories/home/

purge:
	ansible-playbook playbooks/purge_vms.yaml -i inventories/home/

display:
	echo ${HOME}