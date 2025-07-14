# KEDA CPU-based Autoscaling Example

This example demonstrates how to configure KEDA to dynamically scale a Kubernetes deployment based on CPU utilization, leveraging KEDA's integration with the Horizontal Pod Autoscaler (HPA).

## Prerequisites

- A Kubernetes cluster with KEDA installed
- `kubectl` configured to communicate with your cluster

## Files

- `0-flask-app.yaml`: Defines a simple stress test application
- `1-scaledobject.yaml`: Configures KEDA ScaledObject for CPU-based autoscaling

## Deploy the Example

1. Deploy the test application:
   ```bash
   kubectl apply -f 0-flask-app.yaml
   ```

2. Deploy the KEDA ScaledObject:
   ```bash
   kubectl apply -f 1-scaledobject.yaml
   ```

## Verify the Deployment

1. Check the ScaledObject:
   ```bash
   kubectl get scaledobjects
   ```

2. View the HPA created by KEDA:
   ```bash
   kubectl get hpa
   ```

3. Get detailed information about the HPA:
   ```bash
   kubectl describe hpa keda-hpa-cpu-app-scaledobject
   ```

## How It Works

- The `cpu-app` deployment runs a stress test container that consumes CPU.
- The KEDA ScaledObject monitors the CPU utilization of the pods.
- When CPU utilization exceeds 50%, KEDA will scale the deployment up (up to 5 replicas).
- When CPU utilization drops, KEDA will scale the deployment down (minimum 1 replica).

## Cleanup

To remove all resources created by this example:

```bash
kubectl delete -f 1-scaledobject.yaml
kubectl delete -f 0-flask-app.yaml
