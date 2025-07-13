# Cluster Proportional Autoscaler (CPA)

## Overview
The Cluster Proportional Autoscaler (CPA) is a Kubernetes controller that automatically scales system components (such as CoreDNS, kube-dns, or other network proxies) in proportion to the number of nodes or cores in your cluster.

## Key Features
- Scales system components based on cluster size (nodes/cores)
- Complements HPA and VPA by focusing on cluster-level scaling
- Supports multiple scaling methods (linear, ladder)
- Configurable through ConfigMaps

## Deployment Methods
This repository contains multiple deployment approaches:

### 1. Linear Scaling Method
- Located in: `linear_method/`
- Scales components linearly based on cluster size
- Simple configuration for straightforward scaling needs

### 2. Ladder Scaling Method
- Located in: `ladder_method/`
- Provides step-based scaling with defined thresholds
- More granular control over scaling behavior

## Prerequisites
- Kubernetes cluster (EKS, GKE, AKS, or on-premises)
- `kubectl` configured with cluster admin access
- Helm (for some deployment methods)

## Getting Started
1. Choose your preferred scaling method (linear or ladder)
2. Review and customize the configuration in the respective directory
3. Apply the manifests using `kubectl apply -f <directory>`

## Configuration
Customize the scaling behavior by modifying the ConfigMap in your chosen method's directory. Refer to the specific method's README for detailed configuration options.

## Monitoring
Monitor the autoscaler's behavior using:
```bash
kubectl logs -n kube-system -l k8s-app=cluster-proportional-autoscaler
```
## 📚 Additional Resources
- [Kubernetes Cluster Proportional Autoscaler Documentation](https://github.com/kubernetes-sigs/cluster-proportional-autoscaler)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
