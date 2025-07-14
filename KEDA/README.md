# KEDA (Kubernetes Event-Driven Autoscaling)

## Overview
KEDA (Kubernetes Event-Driven Autoscaling) is a Kubernetes-based Event Driven Autoscaling component that extends Kubernetes with event-based scaling capabilities. It allows you to scale your applications based on external events from various sources while maintaining the ability to scale to zero when no events are occurring.

## Why KEDA?

Traditional autoscalers like HPA, VPA, and CPA have limitations when it comes to event-driven scaling scenarios:

### HPA (Horizontal Pod Autoscaler)
- Scales based on CPU/memory metrics only
- Has polling delays that can lead to pod overload
- Cannot scale to zero

### VPA (Vertical Pod Autoscaler)
- Adjusts resource requests per pod
- Causes pod restarts leading to potential downtime
- Not optimized for request-driven scaling

### CPA (Cluster Proportional Autoscaler)
- Only scales system components
- Ignores HTTP request load

## Key Features

- **Event-Driven Scaling**: Scale based on external events from various sources
- **Scale to Zero**: Automatically scale down to zero when no events are occurring
- **Native Kubernetes Integration**: Works seamlessly with Kubernetes primitives
- **Multiple Trigger Sources**: Supports various event sources like message queues, HTTP requests, and Prometheus alerts
- **No Heavy Adapters**: Lightweight implementation without complex custom adapters

## Architecture

KEDA's architecture consists of several key components:

### Core Components
- **KEDA Operator**: Manages ScaledObject and ScaledJob CRDs
- **Metrics Server**: Aggregates external metrics into Kubernetes API-compatible format
- **Admission Webhook**: Validates and mutates scaled objects
- **Trigger Authentication**: Securely stores credentials for external services
- **Scaler**: Interfaces with external event sources

### Custom Resource Definitions (CRDs)
- **ScaledObject**: Links your Deployment or StatefulSet to a scaler
- **ScaledJob**: Similar to ScaledObject but for Kubernetes Jobs
- **TriggerAuthentication**: Stores authentication details for metric sources
- **ClusterTriggerAuthentication**: Cluster-scoped version of TriggerAuthentication
- **EventSource**: Defines custom event sources for autoscaling

## Installation

### Prerequisites
- A running Kubernetes cluster (v1.16+)
- Helm v3+ installed and configured
- `kubectl` configured to communicate with your cluster

### Installation Steps

1. Add the KEDA Helm repository:
   ```bash
   helm repo add kedacore https://kedacore.github.io/charts
   ```

2. Update your local Helm repository:
   ```bash
   helm repo update
   ```

3. Install KEDA in the `keda` namespace:
   ```bash
   helm install keda kedacore/keda \
     --namespace keda \
     --create-namespace
   ```

### Verification

After installation, verify the KEDA installation:

```bash
# Check KEDA resources
kubectl api-resources | grep keda

# Verify API services
kubectl get apiservice
kubectl get apiservice -o custom-columns=NAME:.metadata.name,LABELS:.metadata.labels | grep keda
```

## Getting Started

### Basic Example: HTTP ScaledObject

Here's a basic example of scaling a deployment based on HTTP traffic:

```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: http-scaledobject
  namespace: default
spec:
  scaleTargetRef:
    name: your-deployment
  minReplicaCount: 0
  maxReplicaCount: 10
  triggers:
  - type: http
    metadata:
      target: "5"
      url: http://your-service:8080/metrics
```

## Best Practices

- Set appropriate `minReplicaCount` and `maxReplicaCount` values
- Configure proper resource requests and limits
- Use `TriggerAuthentication` for secure credential management
- Monitor KEDA metrics and logs
- Regularly update to the latest KEDA version

## Troubleshooting

Common issues and solutions:

1. **Metrics not available**:
   - Check if the metrics server is running
   - Verify the ScaledObject configuration
   - Check logs of the KEDA operator

2. **Scaling not working**:
   - Verify the target deployment exists
   - Check the event source configuration
   - Ensure proper RBAC permissions

## Resources

- [KEDA Documentation](https://keda.sh/docs/)
- [GitHub Repository](https://github.com/kedacore/keda)
- [KEDA Examples](https://github.com/kedacore/samples)

## License

KEDA is licensed under the [Apache 2.0 License](https://github.com/kedacore/keda/blob/main/LICENSE).
