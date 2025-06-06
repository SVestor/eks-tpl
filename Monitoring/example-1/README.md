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
kubectl apply -f namespace.yaml
kubectl apply -f storage/storageclass.yaml
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



