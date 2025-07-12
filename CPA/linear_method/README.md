# 🔢 Linear Scaling Method for Custom Pod Autoscaler (CPA)

## 📖 Overview
This configuration demonstrates how to set up a Custom Pod Autoscaler (CPA) in linear mode to dynamically scale a Kubernetes deployment based on cluster resources (CPU cores or nodes).

## 🚀 Quick Start

```bash
# Apply all configuration files
kubectl apply -f .
```

## 🛡️ High Availability Features

### Prevent Single Point of Failure
- **`preventSinglePointFailure: true`** ensures pods are distributed across different nodes
- Prevents multiple pods from being scheduled on the same node
- Enhances reliability by reducing impact of node failures
- Note: This setting only affects pod scheduling, not existing pod placement

## 🧮 Scaling Example

### Cluster Specifications:
- **Schedulable Nodes**: 12
- **Total CPU Cores**: 34

### Configuration Details:
```yaml
# Example configuration (from configmap.yaml)
# ...
"preventSinglePointFailure": true
# ...
```

## 🤔 Knowledge Check

**Question:** 
Given the above cluster specifications and the linear scaling configuration, how many replicas will the CPA provision? What additional reliability features are provided by this configuration?

**Answer:** 
CPA will provision 10 replicas, with configuration ensuring at least 2 replicas due to preventSinglePointFailure. Additionally, CPA will ensure that the pods are distributed across different nodes, as the preventSinglePointFailure setting is enabled.

## 📚 Additional Notes
- The linear scaling method calculates the number of replicas based on the formula defined in the ConfigMap
- The actual number of replicas will depend on the specific parameters set in the ConfigMap
- The autoscaler will continuously monitor the cluster and adjust replicas as needed

## 📝 Next Steps
1. Review the configuration in `0-configmap.yaml`
2. Deploy the application and autoscaler
3. Monitor the scaling behavior with `kubectl get pods -o wide`
4. Test failover by removing nodes (in a non-production environment)
