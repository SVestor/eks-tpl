resource "helm_release" "metrics-server" {
  name = "metrics-server"

  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
  version    = "3.12.2"

  namespace = "kube-system"

  values = [
    file("${path.module}/helm_values/metrics-server.yaml")
  ]

  depends_on = [aws_eks_node_group.eks_main]
}
