## Stress test

### Create 2 pods with different resources requests and limits:
- ubuntu-pod-1: 800m CPU, 1Gi memory
- ubuntu-pod-2: 1500m CPU, 512Mi memory

```bash
kubectl apply -f ubuntu-pod.yaml
```
### Make a stress cpu and memory tests
```bash
kubectl exec -it ubuntu-pod-1 -- bash
kubectl exec -it ubuntu-pod-2 -- bash

# Download stress utility
apt update && apt install -y stress

# In ubuntu-pod-1
stress --cpu 1 --timeout 300s
stress --vm 1 --vm-bytes 800M --vm-keep --timeout 300s

# In ubuntu-pod-2
stress --cpu 1 --timeout 300s
stress --vm 1 --vm-bytes 800M --vm-keep --timeout 300s
```
### Make a network test
```bash
kubectl exec -it ubuntu-pod-1 -- bash
kubectl exec -it ubuntu-pod-2 -- bash

# Download iperf3 utility
apt update && apt install -y iperf3

# In ubuntu-pod-1
iperf3 --server

# In ubuntu-pod-2
iperf3 --client ubuntu-pod-1_ip-address --bidir --time 300
```

