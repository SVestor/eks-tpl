# KEDA Redis List Length Scaling Example

This example demonstrates how to use KEDA (Kubernetes Event-Driven Autoscaling) to automatically scale a Kubernetes deployment based on the number of items in a Redis list.

## Overview

This example includes the following components:
- A Redis server deployment with password authentication
- A simple Nginx deployment that will be scaled based on Redis list length
- KEDA ScaledObject configuration for Redis-based scaling

## Prerequisites

- A Kubernetes cluster with KEDA installed
- `kubectl` configured to communicate with your cluster
- KEDA add-on installed in your cluster

## How It Works

1. The Redis server is deployed with a password-protected instance
2. KEDA monitors the length of a specified Redis list (`mylist` by default)
3. When the number of items in the list exceeds the threshold (10 items), KEDA scales up the Nginx deployment
4. When the list length decreases, KEDA scales down the deployment accordingly

## Deployment

Apply the manifests in the following order:

```bash
# Deploy Redis
kubectl apply -f 0-redis-deployment.yaml
kubectl apply -f 1-redis-service.yaml

# Deploy the target application (Nginx)
kubectl apply -f 3-nginx-target-app.yaml

# Deploy KEDA ScaledObject configuration
kubectl apply -f 4-keda-scaledobject.yaml
```

## Testing the Autoscaling

1. Connect to the Redis pod:
   ```bash
   kubectl exec -it deploy/redis -- redis-cli -a ahinoiuhkjj
   ```

2. Add items to the monitored list to trigger scaling:
   ```
   LPUSH mylist item1 item2 item3 ...
   ```

3. Check the number of Nginx replicas:
   ```bash
   kubectl get pods -l app=nginx
   ```

4. Remove items from the list to scale down:
   ```
   LPOP mylist
   ```

## Advanced Testing Scenarios

### Testing with Redis CLI Pod

1. **Create and access a Redis CLI pod**:
   ```bash
   kubectl run redis-cli --image=redis --restart=Never
   ```

2. **Add items to the monitored list**:
   ```bash
   kubectl exec -it redis-cli -- bash -c "for i in {1..10}; do redis-cli -h redis.default.svc -p 6379 -a jhbnoiuhkjj RPUSH mylist \"item$i\" 2>/dev/null; done"
   ```

3. **Verify scaling**:
   ```bash
   kubectl get pods -l app=nginx
   kubectl get hpa
   ```

### Understanding HPA Behavior

1. **Check current metrics**:
   ```bash
   kubectl describe hpa keda-hpa-redis-scaledobject | grep -i 's0-redis-mylist'
   ```

   > **Note**: The HPA target metric shows as `X/10` where X is the current value. The HPA will trigger scaling when the value reaches or exceeds the threshold (10).

2. **HPA Behavior Explanation**:
   - The HPA monitors the target metric (number of items in Redis list)
   - Scaling occurs when the metric meets or exceeds the threshold (10 items)
   - The HPA may not scale down immediately due to the default `stabilizationWindowSeconds`

### Testing Scale Down

1. **Empty the Redis list**:
   ```bash
   kubectl exec -it redis-cli -- bash -c "redis-cli -h redis.default.svc -p 6379 -a jhbnoiuhkjj del mylist 2>/dev/null"
   ```

2. **Verify the list is empty**:
   ```bash
   kubectl describe hpa keda-hpa-redis-scaledobject | grep -i 's0-redis-mylist'
   # Expected output: "s0-redis-mylist" (target average value): 0 / 10
   ```

3. **Check scale down behavior**:
   ```bash
   kubectl describe hpa keda-hpa-redis-scaledobject
   ```
   > **Note**: The HPA will scale down the deployment to 1 replica after the stabilization period defined by `stabilizationWindowSeconds`.

## FAQ

### How does KEDA's Redis List scaler optimize resource usage?
- **Prevents Overloading**: By scaling pods based on the actual workload in the Redis list
- **Efficient Scaling**: Automatically scales down when the list is empty, ensuring resources are only used when needed
- **Cost-Effective**: Reduces idle resource consumption by only running pods when there's work to process

### How does KEDA handle multiple scalers?
When multiple scalers are configured (e.g., Redis List and CPU):
- KEDA evaluates all scalers independently
- The highest computed replica count from all scalers is used
- For example, if Redis List requires 5 pods but CPU usage suggests 3 (is below the defined threshold), KEDA will scale to 5 pods based on the Redis list length, ignoring CPU usage

### What metrics does KEDA monitor for Redis List scaling?
- **Primary Metric**: Length of the specified Redis list
- **Threshold**: Defined by `listLength` (default: 10 items)
- **Scaling Logic**: Number of pods = ceil(current list length / threshold)

## Configuration

Key parameters in `4-keda-scaledobject.yaml`:

```yaml
spec:
  scaleTargetRef:
    name: nginx  # Target deployment to scale
  triggers:
  - type: redis
    metadata:
      listName: mylist      # Redis list to monitor
      listLength: "10"      # Items per pod before scaling
      address: redis.default.svc:6379
      listLength: "5"       # Target value per pod
      threshold: "1"        # Scale up when list length > threshold * listLength
  minReplicaCount: 1        # Minimum number of pods
  maxReplicaCount: 10       # Maximum number of pods
  pollingInterval: 15       # How often to check metrics (seconds)
  cooldownPeriod: 300       # How long to wait before scaling down (seconds)
```

### Advanced Configuration Options
- `pollingInterval`: Frequency of checking the Redis list (default: 15s)
- `cooldownPeriod`: Minimum time between scaling operations (default: 300s)
- `threshold`: Multiplier for the target value (default: 1.0)
- `metricName`: Custom name for the metric (useful for monitoring)

## Troubleshooting

- If scaling doesn't occur as expected, check the KEDA operator logs:
  ```bash
  kubectl logs -n keda -l app=keda-operator
  ```

- Verify the Redis connection and authentication:
  ```bash
  kubectl exec -it redis-cli -- redis-cli -h redis.default.svc -p 6379 -a jhbnoiuhkjj PING
  ```

## Cleanup

After testing, clean up all resources:

```bash
kubectl delete -f .
kubectl delete pod redis-cli
```

## Security Note

This example uses a simple password for demonstration purposes. In production, consider using Kubernetes Secrets with proper access controls and more secure password management.
