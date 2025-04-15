# Deploy Postgres

helm repo add bitnami https://charts.bitnami.com/bitnami

helm install psql-single bitnami/postgresql --set persistence.existingClaim=postgresql-pv-claim --set volumePermissions.enabled=true --namespace=postgres
