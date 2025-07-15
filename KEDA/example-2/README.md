# KEDA Cron-based Scaling Example

This example demonstrates how to configure KEDA (Kubernetes Event-Driven Autoscaling) to automatically scale a Kubernetes deployment based on a cron schedule.

## Overview

This configuration uses KEDA's Cron Scaler to automatically scale a deployment up during specific time windows. In this example, we scale an NGINX deployment to 3 replicas between 10:00 AM and 3:00 PM UTC every day.

## Configuration

The `scaledobject.yaml` file contains the KEDA ScaledObject configuration with the following key settings:

- **Scale Target**: NGINX deployment
- **Minimum Replicas**: 1 (always running)
- **Scaling Schedule**:
  - **Start Time**: 10:00 AM UTC (`0 10 * * *`)
  - **End Time**: 3:00 PM UTC (`0 15 * * *`)
  - **Desired Replicas During Active Window**: 3

## How It Works

1. KEDA monitors the cron schedule defined in the ScaledObject
2. When the start time (10:00 AM UTC) is reached, KEDA scales the deployment to 3 replicas
3. At the end time (3:00 PM UTC), KEDA scales the deployment back down to the minimum replica count (1)

## Prerequisites

- Kubernetes cluster
- KEDA installed in your cluster
- `kubectl` configured to communicate with your cluster

## Usage

1. Ensure KEDA is installed in your cluster
2. Deploy your application (e.g., NGINX)
3. Apply the ScaledObject:
   ```bash
   kubectl apply -f scaledobject.yaml
   ```

## Customization

You can modify the following parameters in `scaledobject.yaml`:

- `timezone`: Change the timezone (uses IANA Time Database format)
- `start`: Adjust the start time using cron syntax
- `end`: Adjust the end time using cron syntax
- `desiredReplicas`: Change the number of replicas to scale to during the active window

## Verification

To verify the scaling is working:

```bash
# Check the ScaledObject status
kubectl get scaledobject

# Monitor the deployment scale
kubectl get deployment nginx -w
```

## Cleanup

To remove the ScaledObject:

```bash
kubectl delete -f scaledobject.yaml
```
