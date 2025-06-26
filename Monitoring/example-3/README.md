## Monitoring HTTP/REST API with Prometheus and Grafana

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

### Deploy monitoring resources
```bash
kubectl apply -f cadvisor/
kubectl apply -f kube-state-metrics/
kubectl apply -f ingress-nginx/service-monitor.yaml
```
### Build app [server/client]
```bash
./build-server.sh
./build-client.sh
```

### Deploy server app
```bash
kubectl apply -f app/deploy/
```

### Check server logs
```bash
kubectl logs -l app=gin-server -n staging -f
```

### Generate traffic to API / Start client
```bash
# MODE — specifies the logic: general (default) or errors
# SLEEP_MS — delay between requests in milliseconds

# Run client in a container
docker run --rm svestor/app-client:v1.0.1-2025-06-24 # general mode
docker run --rm -e MODE=errors -e SLEEP_MS=1000 svestor/app-client:v1.0.1-2025-06-24

# Run client with make
make run
MODE=errors SLEEP_MS=1000 ./app-client

# Run client with cli
go run client.go
MODE=errors SLEEP_MS=1000 go run client.go

# Run client in pod
kubectl run app-client -l app=app-client --image=svestor/app-client:v1.0.1-2025-06-24 --restart=Always

kubectl run app-client -l app=app-client --image=svestor/app-client:v1.0.1-2025-06-24 \
  --restart=Always \
  --env="MODE=errors" \
  --env="SLEEP_MS=1000"

kubectl logs -l app=app-client -n default -f

kubectl delete po -l app=app-client -n default
```

### Deploy grafana with helm example (the current deployment uses terraform helm provider)
```bash
# Grafana is already deployed by terraform
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
