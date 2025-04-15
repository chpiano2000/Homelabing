.PHONY: deploy
deploy: 
	helm install vault hashicorp/vault \
    --namespace vault \
    -f override-values.yml \
    --create-namespace
