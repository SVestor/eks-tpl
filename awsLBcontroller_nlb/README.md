## Supported annotations

### Load balancer attributes

- service.beta.kubernetes.io/aws-load-balancer-type specifies the load balancer type. This controller reconciles those service resources with this annotation set to either nlb-ip or external

- service.beta.kubernetes.io/aws-load-balancer-nlb-target-type specifies the target type to configure for NLB. You can choose between instance and ip

#### instance mode

instance mode will route traffic to all EC2 instances within cluster on the NodePort opened for your service. The kube-proxy on the individual worker nodes sets up the forwarding of the traffic from the NodePort to the pods behind the service.

#### ip mode

ip mode will route traffic directly to the pod IP. In this mode, AWS NLB sends traffic directly to the Kubernetes pods behind the service, eliminating the need for an extra network hop through the worker nodes in the Kubernetes cluster.

ip target mode supports pods running on AWS EC2 instances and AWS Fargate
network plugin must use native AWS VPC networking configuration for pod IP, for example Amazon VPC CNI plugin

- service.beta.kubernetes.io/aws-load-balancer-scheme specifies whether the NLB will be internet-facing or internal. Valid values are internal, internet-facing. If not specified, default is internal

- service.beta.kubernetes.io/aws-load-balancer-proxy-protocol specifies whether to enable proxy protocol v2 on the target group. Set to '*' to enable proxy protocol v2. This annotation takes precedence over the annotation service.beta.kubernetes.io/aws-load-balancer-target-group-attributes for proxy protocol v2 configuration

The only valid value for this annotation is *.

- [Supported annotations](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.7/guide/service/annotations/#load-balancer-attributes)
