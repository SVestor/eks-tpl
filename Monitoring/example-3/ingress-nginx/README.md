# Nginx Ingress Controller Monitoring

This directory contains PromQL queries for monitoring the Nginx Ingress Controller in your Kubernetes cluster. These queries help track key performance metrics including latency, traffic, and availability.

## Available Queries

### 1. Latency Metrics

#### P99 Latency (99th Percentile)
```promql
histogram_quantile(
    0.99, 
    sum(
        rate(
            nginx_ingress_controller_request_duration_seconds_bucket{
                ingress=~"$ingress",
                status=~"$status",
                method=~"$method"
            }[1m]
        )
    ) by (le, ingress)
)
```

#### P90 Latency (90th Percentile)
```promql
histogram_quantile(
    0.90, 
    sum(
        rate(
            nginx_ingress_controller_request_duration_seconds_bucket{
                ingress=~"$ingress",
                status=~"$status",
                method=~"$method"
            }[1m]
        )
    ) by (le, ingress)
)
```

#### P50 Latency (Median)
```promql
histogram_quantile(
    0.50, 
    sum(
        rate(
            nginx_ingress_controller_request_duration_seconds_bucket{
                ingress=~"$ingress",
                status=~"$status",
                method=~"$method"
            }[1m]
        )
    ) by (le, ingress)
)
```

### 2. Traffic Rate

Shows the request rate per second for each ingress:

```promql
round(
    sum(
        irate(
            nginx_ingress_controller_requests{
                ingress=~"$ingress"
            }[1m]
        )
    ) by (ingress), 
    0.001
)
```

### 3. Availability

Calculates the ratio of successful requests (non-4xx/5xx responses) to total requests:

```promql
sum(
    rate(
        nginx_ingress_controller_requests{
            ingress=~"$ingress",
            status!~"[4-5].*"
        }[1m])) by (ingress) 
/
sum(
    rate(
        nginx_ingress_controller_requests{
            ingress=~"$ingress"
        }[1m])) by (ingress)
```

## Variables Used

- `$ingress`: Ingress resource name (regex supported)
- `$status`: HTTP status code filter (regex supported)
- `$method`: HTTP method filter (regex supported)

## Usage

These queries are designed to be used with Grafana dashboards or Prometheus's expression browser. The variables can be customized based on your specific monitoring needs.

## Metrics Description

- `nginx_ingress_controller_request_duration_seconds_bucket`: Histogram of request durations
- `nginx_ingress_controller_requests`: Counter of HTTP requests processed

## Alerting

Consider setting up alerts based on these metrics, for example:
- Alert when P99 latency exceeds a certain threshold
- Alert when error rate (5xx responses) exceeds a certain percentage
- Alert when traffic drops below expected levels
