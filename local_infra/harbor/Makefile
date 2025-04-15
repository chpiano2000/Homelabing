install:
	helm upgrade --namespace harbor --install \
   --create-namespace harbor oci://registry-1.docker.io/bitnamicharts/harbor \
   -f values.yaml

update:
	helm upgrade --namespace harbor --install \
   --create-namespace harbor oci://registry-1.docker.io/bitnamicharts/harbor \
   -f values.yaml


uninstall:
	helm uninstall --namespace harbor harbor

