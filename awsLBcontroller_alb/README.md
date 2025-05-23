## Test ingress

```bash
kubectl apply -f .

kubectl get ingress -n flask-ns

curl -i --header "Host: flask-app.api.dev.svestor.link" http://k8s-flask-app-alb-core-eks-dev-817091074.us-east-1.elb.amazonaws.com ; echo

curl -i https://flask-app.api.dev.svestor.link; echo

kubectl delete -f .
```
## Ingress annotations

- [Supported annotations](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.7/guide/ingress/annotations/)
