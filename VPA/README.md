# Vertical Pod Autoscaler (VPA) for K8s

This directory contains Kubernetes manifests for deploying the Vertical Pod Autoscaler (VPA) on K8s cluster. VPA automatically adjusts the CPU and memory requests and limits of your pods based on usage data, helping to optimize resource utilization.

## Components

The VPA deployment consists of the following components:

1. **Admission Controller** - Modifies pod resource requests and limits when pods are created
2. **Recommender** - Analyzes resource usage and provides recommendations
3. **Updater** - Terminates pods to apply new resource recommendations
4. **RBAC** - Required roles and permissions for VPA components
5. **CRDs** - Custom Resource Definitions for VPA objects

## Directory Structure

```
VPA/
├── kustomization.yaml      # Kustomize configuration for VPA deployment
└── vpa_deploy/
    ├── 0-admission-controller-deployment.yaml  # VPA admission controller
    ├── 1-admission-controller-service.yaml     # Service for admission controller
    ├── 2-recommender-deployment.yaml           # VPA recommender
    ├── 3-updater-deployment.yaml               # VPA updater
    ├── 4-vpa-rbac.yaml                         # RBAC rules for VPA
    └── 5-vpa-v1-crd-gen.yaml                   # VPA CRDs
```

## Prerequisites

- Kubernetes cluster (any) 1.16 or later
- `kubectl` configured to communicate with your cluster
- `kustomize` (optional, if using kustomize for deployment)

## Deployment

### Using kubectl

```bash
kubectl apply -f vpa_deploy/
```

### Using kustomize

```bash
kubectl apply -k .
```

## Verifying the Installation

Check that all VPA components are running:

```bash
kubectl get pods -n kube-system | grep vpa
```

## Usage

1. Create a VPA resource for your deployment:

```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: my-app-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind:       Deployment
    name:       my-app
  updatePolicy:
    updateMode: "Auto"
```

2. Apply the VPA configuration:

```bash
kubectl apply -f my-app-vpa.yaml
```

## Viewing Recommendations

To view VPA recommendations for your pods:

```bash
kubectl describe vpa <vpa-name>
```

## Cleanup

To remove VPA from your cluster:

```bash
kubectl delete -f vpa_deploy/
```

## Important Notes

- VPA in `Auto` mode will automatically terminate and recreate pods with new resource requests/limits
- Ensure proper resource quotas are set to prevent resource starvation
- Monitor the cluster after deployment to ensure stable operation
- Test VPA in a non-production environment first

## Troubleshooting

Check VPA component logs:

```bash
kubectl logs -n kube-system -l app=vpa-admission-controller
kubectl logs -n kube-system -l app=vpa-recommender
kubectl logs -n kube-system -l app=vpa-updater
```

## References

- [Kubernetes VPA Documentation](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler)
- [AWS EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [VPA FAQ](https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/FAQ.md)
