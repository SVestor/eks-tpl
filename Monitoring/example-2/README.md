## Monitoring Persistent Volume usage with Prometheus and Grafana

### Update kubeconfig

```bash
aws eks update-kubeconfig \
  --profile cloud-user \
  --region us-east-1 \
  --alias cloud_user@core-eks-dev \
  --name core-eks-dev
```
### Deploy prometheus stack

```bash
kubectl apply -f namespace.yaml # Already created by terraform
kubectl apply -f storage/storageclass.yaml # Already created by terraform
kubectl apply --server-side -f prometheus-operator/crds/
kubectl apply -f prometheus-operator/rbac/
kubectl apply -f prometheus-operator/prometheus-operator-deployment/
kubectl apply -f prometheus/
```

### Check prometheus operator logs

```bash
kubectl logs -l app.kubernetes.io/name=prometheus-operator -n monitoring -f
```
```bash
kubectl logs -l app.kubernetes.io/name=prometheus -n monitoring -f
```
```bash
kubectl port-forward svc/prometheus-operated 9090:9090 -n monitoring &
http://localhost:9090
```

### Deploy app
```bash
kubectl apply -f app/deploy/
```

### Check app metrics
```bash
kubectl port-forward svc/myapp-prom 8081:8081 -n staging &
http://localhost:8081
```

### Deploy kubelet SeriviceMonitor
```bash
kubectl apply -f kubelet-service-monitor/service-monitor.yaml
```

### Deploy grafana with helm example (the current deployment uses terraform helm provider)
```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm search repo grafana
helm show values grafana/grafana --version 9.2.2
helm show values grafana/grafana --version 9.2.2 > grafana-values.yaml
helm install grafana grafana/grafana --version 9.2.2 -n grafana
helm upgrade grafana grafana/grafana -f grafana-values.yaml -n grafana
```

### Check grafana logs
```bash
kubectl logs -l app.kubernetes.io/name=grafana -n grafana -f
```
```bash
kubectl port-forward svc/grafana 3000:80 -n grafana &
```

### Check grafana dashboard
```bash
http://localhost:3000
```
### Testing Storage Capacity
```bash
kubectl exec -it prometheus-main-0 -n monitoring  -- sh 
dd if=/dev/zero of=/prometheus/test.file bs=1G count=10
```

```bash
kubectl exec -it prometheus-main-1 -n monitoring  -- sh 
dd if=/dev/zero of=/prometheus/test.file bs=1G count=5
```
### Testing kube-state-metrics
```bash
kubectl apply -f kube-state-metrics/
kubectl apply -f test-pvc.yaml
```
