play:
	ansible-playbook playbook.yaml -i inventory/hosts.ini --ask-become-pass

purge:
	ansible-playbook purge_playbook.yaml -i inventory/hosts.ini --ask-become-pass

display:
	echo ${HOME}