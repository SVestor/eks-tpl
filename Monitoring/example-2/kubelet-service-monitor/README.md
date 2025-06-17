## Deploy kubelet ServiceMonitor explanation

### What happens kubelet-service-monitor.yaml:

    Prometheus will scrape both paths: /metrics and /metrics/cadvisor.
    They will be considered as separate targets, but logically grouped in one ServiceMonitor

### When is it better to keep them separate cadvisor-service-monitor.yaml:

    If you want to manage retention, relabeling, metricRelabelConfigs, or other policies separately
    If you need to split scrape logic by job
    If you have different security requirements for /metrics and /metrics/cadvisor

### When deploy cadvisor DaemonSet as a separate component ./example-2/cadvisor:

    You don't have access to kubelet, or
    kubelet does not expose cadvisor metrics, or
    you need more specific details, metrics filtered, about each container than kubelet provides

Then you can deploy cAdvisor as a separate DaemonSet
