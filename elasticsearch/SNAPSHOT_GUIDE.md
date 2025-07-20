# Elasticsearch Snapshot Automation

Simple snapshot automation for Elasticsearch with Azure blob storage.

## What it does:

1. **Waits for Elasticsearch** to be ready
2. **Creates Azure repository** if it doesn't exist
3. **Creates snapshots** every 2 minutes (configurable)
4. **Cleans up old snapshots** based on retention policy

## Quick Deploy:

```bash
# 1. Create Azure credentials secret
kubectl create secret generic elasticsearch-azure-credentials \
  --from-literal=azure.client.default.account=YOUR_STORAGE_ACCOUNT \
  --from-literal=azure.client.default.key=YOUR_STORAGE_KEY

# 2. Deploy Elasticsearch with snapshot automation
helm install elasticsearch ./elasticsearch \
  --set snapshotAutomation.enabled=true \
  --set snapshotAutomation.azureStorage.container=your-container-name \
  --set extraEnvVarsSecret=elasticsearch-azure-credentials
```

## Configuration:

```yaml
snapshotAutomation:
  enabled: true
  schedule:
    cron: "*/2 * * * *"  # Every 2 minutes
  retention:
    days: 30
    maxSnapshots: 100
  azureStorage:
    container: "elasticsearch-snapshots"
    basePath: "snapshots"
```

## Monitor:

```bash
# Check job status
kubectl get cronjob elasticsearch-snapshot-job

# Check recent jobs
kubectl get jobs -l app.kubernetes.io/name=elasticsearch

# Check job logs
kubectl logs job/elasticsearch-snapshot-job-<timestamp>

# List snapshots
kubectl exec -it elasticsearch-master-0 -- curl -s "http://elasticsearch:9200/_snapshot/azure-repo/_all" | jq '.'
```

## Manual Trigger:

```bash
# Trigger snapshot immediately
kubectl create job --from=cronjob/elasticsearch-snapshot-job manual-snapshot-$(date +%Y%m%d-%H%M%S)
```

That's it! The job will automatically handle everything. 