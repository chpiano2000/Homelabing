install:
	helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace

uninstall:
	helm uninstall --namespace ingress-nginx ingress-nginx
