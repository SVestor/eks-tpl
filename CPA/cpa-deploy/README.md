# 🚀 Cluster Proportional Autoscaler (CPA)

A Kubernetes add-on that scales the number of pods in a deployment, replication controller, or replica set based on the number of nodes or CPU cores available in the cluster.

## 📋 Prerequisites

- Kubernetes cluster
- `kubectl` configured to communicate with your cluster
- Helm (for Helm installation method)

## 🛠️ Installation

### Method 1: Using kubectl (Direct Apply)

```bash
# Apply all configuration files in the current directory
kubectl apply -f .

# Verify the pods are running
kubectl get pods -n autoscaler
```

### Method 2: Using Helm (Recommended)

1. Add the Helm repository:
   ```bash
   helm repo add cluster-proportional-autoscaler https://kubernetes-sigs.github.io/cluster-proportional-autoscaler
   helm repo update
   ```

2. Install the Cluster Proportional Autoscaler:
   ```bash
   helm install cluster-proportional-autoscaler \
     cluster-proportional-autoscaler/cluster-proportional-autoscaler \
     --values ./helm_values/cpa_default.yaml \
     -n autoscaler \
     --create-namespace
   ```

## 🔍 Verification

After installation, verify that the autoscaler is running:

```bash
# Check running pods
kubectl get pods -n autoscaler

# Get pod names
kubectl get po -n autoscaler -o name | grep -oP '(?<=pod/).*'

# Verify service account
kubectl get sa -n autoscaler -o name | grep -oP 'cluster.*'
```

## ⚙️ Configuration

Customize the autoscaler behavior by modifying the values in `./helm_values/cpa_default.yaml` before installation.

## 📚 Additional Resources

- [Kubernetes Cluster Proportional Autoscaler GitHub](https://github.com/kubernetes-sigs/cluster-proportional-autoscaler)
- [Kubernetes Documentation](https://kubernetes.io/)
