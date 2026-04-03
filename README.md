# ai-monitoring-elasticsearch

Elasticsearch for the AI Log Monitoring system (log indexing and search). Deploys via Bitnami Helm chart.



## Prerequisite

`ai-monitoring-secrets` must exist. Run **ai-monitoring-postgresql** first, or create the secret manually.

## Quick start

```bash
./deployments/install.sh
```

## Deploy via PR comment

`/deploy aks` or `/deploy openshift` on any PR

## Required GitHub secrets

- **AKS:** AZURE_CREDENTIALS, AKS_RESOURCE_GROUP, AKS_CLUSTER_NAME
- **OpenShift:** OPENSHIFT_TOKEN, OPENSHIFT_SERVER, OPENSHIFT_PROJECT
- **Both:** DB_PASSWORD, JWT_SECRET
- **Optional:** REDIS_PASSWORD, RABBITMQ_PASSWORD (default to DB_PASSWORD)
