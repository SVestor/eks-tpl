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
