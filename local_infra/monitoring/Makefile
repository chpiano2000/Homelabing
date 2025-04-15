install:
	helm upgrade --namespace monitor --create-namespace \
		--install prometheus-community https://prometheus-community.github.io/helm-charts \
		-f prometheus.yaml

install_grafana:
	helm upgrade --namespace monitor --create-namespace \
		--install grafana grafana/grafana \
		-f grafana.yaml



