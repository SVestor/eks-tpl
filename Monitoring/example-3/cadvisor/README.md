# cAdvisor PromQL Queries Documentation

This document provides documentation for the PromQL queries used to monitor container metrics in Kubernetes using cAdvisor.

## Table of Contents
- [CPU Metrics](#cpu-metrics)
- [Memory Metrics](#memory-metrics)
- [Network Metrics](#network-metrics)
- [Variables](#variables)

## CPU Metrics

### CPU Usage (% of Limits)
```promql
sum(
  rate(container_cpu_usage_seconds_total{
    container_label_io_kubernetes_pod_namespace=~"$namespace",
    image!="",
    container_label_io_cri_containerd_kind="container"
  }[1m])
)
by (container_label_io_kubernetes_pod_name, container_label_io_kubernetes_container_name)
/
sum(
  container_spec_cpu_quota{
    container_label_io_kubernetes_pod_namespace=~"$namespace",
    image!="",
    container_label_io_cri_containerd_kind="container"
  }
  /
  container_spec_cpu_period{
    container_label_io_kubernetes_pod_namespace=~"$namespace",
    image!="",
    container_label_io_cri_containerd_kind="container"
  }
)
by (container_label_io_kubernetes_pod_name, container_label_io_kubernetes_container_name)
```
Shows CPU usage as a percentage of the container's CPU limit.

### CPU Throttling
```promql
rate(
  container_cpu_cfs_throttled_seconds_total
  {
    container_label_io_kubernetes_pod_namespace=~"$namespace",
    image!="",
    container_label_io_cri_containerd_kind="container"
  }[1m])
```
Measures the rate of CPU throttling for containers.

### CPU Usage (Cores) with Requests and Limits
```promql
sum(
  rate(
    container_cpu_usage_seconds_total
    {
       container_label_io_kubernetes_pod_name=~"$pod",
       container_label_io_kubernetes_container_name=~"$container",
       container_label_io_kubernetes_pod_namespace=~"$namespace",
       image!="",
       container_label_io_cri_containerd_kind="container"
    }[1m]
  )
)
by (container_label_io_kubernetes_pod_name,container_label_io_kubernetes_container_name)
```
Shows actual CPU usage in cores along with configured requests and limits.

## Memory Metrics

### Memory Usage (% of Limit)
```promql
container_memory_working_set_bytes
{
  container_label_io_kubernetes_pod_namespace=~"$namespace",
  container_label_io_kubernetes_pod_name=~"$pod",
  container_label_io_kubernetes_container_name=~"$container",
  container_label_io_cri_containerd_kind="container"
} / 
container_spec_memory_limit_bytes
{
  container_label_io_kubernetes_pod_namespace=~"$namespace",
  container_label_io_kubernetes_pod_name=~"$pod",
  container_label_io_kubernetes_container_name=~"$container",
  container_label_io_cri_containerd_kind="container"
}
```
Shows memory usage as a percentage of the container's memory limit.

### Memory Usage (Bytes) with Requests and Limits
```promql
container_memory_working_set_bytes
{
  container_label_io_kubernetes_pod_namespace=~"$namespace",
  container_label_io_kubernetes_pod_name=~"$pod",
  container_label_io_kubernetes_container_name=~"$container",
  container_label_io_cri_containerd_kind="container"
}
```
Shows actual memory usage in bytes along with configured requests and limits.

## Network Metrics

### Network I/O Pressure
```promql
# Receive rate (bits/s)
irate(
    container_network_receive_bytes_total
    {
        container_label_io_kubernetes_pod_namespace=~"$namespace",
        container_label_io_kubernetes_pod_name=~"$pod"
    }[1m]) * 8

# Transmit rate (bits/s)
irate(
    container_network_transmit_bytes_total
    {
        container_label_io_kubernetes_pod_namespace=~"$namespace",
        container_label_io_kubernetes_pod_name=~"$pod"
    }[1m]) * 8
```
Measures network I/O pressure in bits per second for both receive and transmit directions.

### Packet Drop Rate
```promql
# Receive packet drop rate
irate(
    container_network_receive_packets_dropped_total
    {
        container_label_io_kubernetes_pod_namespace=~"$namespace",
        container_label_io_kubernetes_pod_name=~"$pod"
    }[1m]
)

# Transmit packet drop rate
irate(
    container_network_transmit_packets_dropped_total
    {
        container_label_io_kubernetes_pod_namespace=~"$namespace",
        container_label_io_kubernetes_pod_name=~"$pod"
    }[1m]
)
```
Measures the rate of packet drops for both receive and transmit directions.

## Variables

These queries use the following variables that should be defined in your Grafana dashboard:

- `$namespace`: Kubernetes namespace to filter metrics
- `$pod`: Pod name (supports regex)
- `$container`: Container name (supports regex)

## Usage Notes

1. These queries are designed to work with cAdvisor metrics in a Kubernetes environment.
2. The queries filter out metrics from the pause container using `image!=""`.
3. All queries filter by the containerd runtime using `container_label_io_cri_containerd_kind="container"`.
4. Network metrics are shown in bits per second (multiplied by 8 from bytes).
5. Memory metrics show the working set size, which is the amount of memory that's actively being used.

For best results, use these queries in a Grafana dashboard with appropriate variables configured for namespace, pod, and container selection.
