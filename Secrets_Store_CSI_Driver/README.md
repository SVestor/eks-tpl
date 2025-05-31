# Secrets Store CSI Driver

Secrets Store CSI Driver is a CSI driver for Kubernetes that provides a way to mount secrets from AWS Secrets Manager and AWS Systems Manager Parameter Store into a Kubernetes pod.

### EKS K8s Commands

```bash
kubectl logs -l app.kubernetes.io/instance=secrets-store-csi-driver -n kube-system -f
```

```bash
kubectl get secret flask-app-secrets -n flask-ns -o yaml
```

```bash
kubectl exec flask-app-5d867cb968-4xbnc -n flask-ns -it -- /bin/bash
```

```bash
ls /mnt/secrets-store
```

```bash
env | grep FLASK_APP_
```

```bash
printenv | grep FLASK_APP_
```

### Preferred Address Type (preferredAddressType)

An optional field that specifies the preferred IP address type for Pod Identity Agent endpoint communication. The field is only applicable when using EKS Pod Identity feature and will be ignored when using IAM Roles for Service Accounts.

Values are case-insensitive. Valid values are:

- `"ipv4"` , `"IPv4"`, `"IPV4"`: Force the use of Pod Identity Agent IPv4 endpoint
- `"ipv6"` , `"IPv6"`, `"IPV6"`: Force the use of Pod Identity Agent IPv6 endpoint
- not specified: Use auto endpoint selection, trying IPv4 endpoint first and falling back to IPv6 endpoint if IPv4 fails

### Example

```yaml
preferredAddressType: "ipv4"
```

### Region (region)

An optional field to specify the AWS region to use when retrieving secrets from Secrets Manager or Parameter Store. If this field is missing, the provider will lookup the region from the topology.kubernetes.io/region label on the node. This lookup adds overhead to mount requests so clusters using large numbers of pods will benefit from providing the region here.

### Example

```yaml
region: "us-east-1"
```
### Supported Documentations

- [Secrets Store CSI Driver](https://secrets-store-csi-driver.sigs.k8s.io/introduction)
- [Secrets Store CSI Driver GitHub](https://github.com/kubernetes-sigs/secrets-store-csi-driver)
- [Secrets Store CSI Driver Provider AWS GitHub](https://github.com/aws/secrets-store-csi-driver-provider-aws)
