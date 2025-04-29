up:
	vagrant up

down:
	vagrant destroy

kubeconfig:
	scp vagrant@controller:/etc/rancher/rke2/rke2.yaml .
