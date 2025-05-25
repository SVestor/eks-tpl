## Test ingress

```bash
kubectl apply -f .

kubectl get secret dns01-prod-cluster-issuer -n cert-manager

kubectl get clusterissuer -n flask-ns

kubectl get certificate -n flask-ns

kubectl describe certificate flask-app-svestor-link-tls -n flask-ns

kubectl get order -n flask-ns

kubectl get challenge -n flask-ns

kubectl get secret -n flask-ns

kubectl get secret flask-app-svestor-link-tls -o jsonpath="{.data.tls\.key}" -n flask-ns | base64 --decode

kubectl get secret flask-app-svestor-link-tls -o jsonpath="{.data.tls\.crt}" -n flask-ns | base64 --decode

kubectl get ingress -n flask-ns

curl -i --header "Host: flask-app.svestor.link" http://k8s-ingressn-external-2f75eccde0-1c2b0108d65780bb.elb.us-east-1.amazonaws.com ; echo

curl -i https://flask-app.svestor.link; echo

kubectl delete -f .
```
## Ingress-nginx annotations

- [Supported annotations for nlb](https://kubernetes.github.io/ingress-nginx/deploy/)

## Cert-manager

- [Supported configuration](https://cert-manager.io/docs/configuration/acme/dns01/route53/)

- [Cert-manager github](https://github.com/cert-manager/cert-manager/blob/master/deploy/charts/cert-manager/values.yaml)

## Let's Encrypt

- [Let's Encrypt](https://letsencrypt.org/getting-started/)
