# EKS Monitoring Stack with Cert Manager, NLB, Nginx Ingress, Let's Encrypt, Grafana, and Prometheus

This repository contains Terraform configurations and Kubernetes manifests to deploy a comprehensive monitoring stack on Amazon EKS (Elastic Kubernetes Service). The setup includes:

- **Cert Manager**: For managing TLS certificates
- **AWS Network Load Balancer (NLB)**: For exposing services
- **Nginx Ingress Controller**: For managing ingress traffic
- **Let's Encrypt**: For automatic SSL certificate provisioning
- **Grafana**: For visualization and dashboards
- **Prometheus**: For metrics collection and monitoring
- **Kubernetes**: The underlying container orchestration platform

## Prerequisites

- AWS CLI configured with appropriate permissions
- `kubectl` installed and configured
- `helm` installed
- Terraform >= 1.0.0
- An existing EKS cluster (or modify the Terraform to create one)

## Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│                 │     │                 │     │                 │
│   Prometheus    │◄────┤   Nginx Ingress │◄────│       NLB       │
│                 │     │                 │     │                 │
└────────┬────────┘     └────────┬────────┘     └─────────────────┘
         │                       │
         │                       │
┌────────▼───────┐     ┌────────▼────────┐
│                │     │                 │
│    Grafana     │     │  Applications   │
│                │     │                 │
└────────────────┘     └─────────────────┘
```

## Components

### Cert Manager
Manages TLS certificates automatically using Let's Encrypt. Certificates are automatically renewed before they expire.

### AWS NLB
Provides network load balancing for the EKS cluster, routing traffic to the appropriate services.

### Nginx Ingress Controller
Manages external access to services in the cluster, typically HTTP/HTTPS.

### Let's Encrypt
Provides free TLS certificates through the ACME protocol, automated by Cert Manager.

### Grafana
Visualization platform for all your metrics with pre-configured dashboards for Kubernetes monitoring.

### Prometheus
Monitors and collects metrics from the Kubernetes cluster and applications.

## Deployment

### 1. Clone the repository
```bash
git clone <repository-url>
cd eks-monitoring-stack
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Review and update variables
Edit `terraform.tfvars` to match your configuration:

```hcl
cluster_name     = "your-eks-cluster-name"
region          = "us-west-2"
domain_name     = "example.com"
email           = "admin@example.com"
```

### 4. Apply the configuration
```bash
terraform apply
```

## Accessing the Dashboards

### Grafana
After deployment, Grafana will be available at:
```
https://grafana.your-domain.com
```
Default credentials:
- Username: admin
- Password: (check the Kubernetes secret)

### Prometheus
Prometheus UI is available at:
```
https://prometheus.your-domain.com
```

## Maintenance

### Upgrading Components
To upgrade any component, update the corresponding Helm chart version in the Terraform configuration and run:

```bash
terraform apply
```

### Monitoring Alerts
Pre-configured alerts are available in the `alerts/` directory. These can be customized as needed.

## Troubleshooting

Common issues and their solutions:

1. **Certificate not issued**
   - Check Cert Manager logs: `kubectl logs -n cert-manager -l app=cert-manager`
   - Verify DNS records are properly configured

2. **Ingress not working**
   - Check Nginx Ingress Controller logs
   - Verify AWS NLB target groups are healthy

## Cleanup

To remove all resources:

```bash
terraform destroy
```
