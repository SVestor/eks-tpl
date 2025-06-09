variable "eks_subnets" {
  type = map(any)
  default = {
    private = [
      {
        ip = "10.0.0.0/19"
        az = "us-east-1a"
      },
      {
        ip = "10.0.32.0/19"
        az = "us-east-1b"
      }
    ]
    public = [
      {
        ip = "10.0.64.0/19"
        az = "us-east-1a"
      },
      {
        ip = "10.0.96.0/19"
        az = "us-east-1b"
      }
    ]
  }
}

variable "dns_zone_name" {
  description = "Domain name"
  default     = "svestor.link"
}

variable "subdomain" {
  description = "Subdomain for each environmemnt"
  type        = map(string)

  default = {
    "prod"    = "api"
    "staging" = "api.stg"
    "dev"     = "api.dev"
  }
}

variable "grafana_admin_user" {
  description = "Grafana admin user"
  type        = string
  default     = "superadmin"
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  default     = "MySuperSecretPassword"
  sensitive   = true
}
