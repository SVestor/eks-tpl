# cAdvisor Monitoring Queries

This directory contains PromQL queries for monitoring container resources using cAdvisor metrics in a Kubernetes environment. These queries can be used with monitoring solutions like Prometheus and Grafana to gain insights into container performance and resource utilization.

## Available Metrics

### CPU Monitoring

1. **CPU Usage (% of Limits)**
   - Shows CPU usage as a percentage of the defined CPU limits
   - Query: [cpu_usage_percent.promql](queries.promql#L1-L25)

2. **CPU Throttling**
   - Measures the amount of CPU throttling experienced by containers
   - Query: [cpu_throttling.promql](queries.promql#L29-L39)

3. **CPU Usage (Cores) with Requests and Limits**
   - Shows actual CPU usage along with configured requests and limits
   - Query: [cpu_usage_cores.promql](queries.promql#L41-L76)

### Memory Monitoring

1. **Memory Usage (% of Limit)**
   - Shows memory usage as a percentage of the defined memory limit
   - Query: [memory_usage_percent.promql](queries.promql#L78-L93)

2. **Memory Usage (Bytes) with Requests and Limits**
   - Shows actual memory usage along with configured requests and limits
   - Query: [memory_usage_bytes.promql](queries.promql#L95-L130)

### Network Monitoring

1. **Network I/O Pressure**
   - Measures network receive and transmit rates in bits per second
   - Query: [network_io.promql](queries.promql#L132-L147)

2. **Packet Drop Rate**
   - Tracks the rate of dropped network packets
   - Query: [packet_drop_rate.promql](queries.promql#L149-L167)

## Usage

These queries use the following variables that should be configured in your monitoring solution:

- `$namespace`: Kubernetes namespace filter
- `$pod`: Pod name filter
- `$container`: Container name filter

## Requirements

- Prometheus with cAdvisor metrics collection configured
- Kubernetes cluster with cAdvisor running on nodes
- kube-state-metrics for resource requests and limits

## Visualization

These queries can be used to create dashboards in Grafana or other monitoring solutions. Consider creating panels for:

- CPU and memory usage trends over time
- Resource utilization vs. requests/limits
- Network I/O and error rates
- Alerting on thresholds (e.g., CPU throttling, memory pressure)

## Notes

- All queries filter for actual containers (excluding Pause containers) using `image!=""` and `container_label_io_cri_containerd_kind="container"`
- Network metrics are multiplied by 8 to convert bytes to bits for standard network rate display
- Rates are calculated over a 1-minute window for balance between responsiveness and stability
