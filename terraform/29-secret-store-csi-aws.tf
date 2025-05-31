# Note: For the current version of secret-store-csi-driver-provider-aws 
# EKS Pod Identity option is only supported for EKS in the Cloud. 
# It's not supported for Amazon EKS Anywhere, Red Hat Openshift Service on AWS (ROSA) 
# and self-managed Kubernetes clusters on Amazon Elastic Compute Cloud (Amazon EC2) instances.

# Get secret name from AWS Secrets Manager
data "aws_secretsmanager_secret" "flask_app_secret" {
  name = "dev/flask-app-secret-v1"
}

data "aws_iam_policy_document" "flask_app_secrets" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "flask_app_secrets" {
  name = "${local.eks_cluster_name}-${local.env}-flask-app-secrets-csi-iam-role"

  assume_role_policy = data.aws_iam_policy_document.flask_app_secrets.json

  tags = local.common_tags
}

resource "aws_iam_policy" "flask_app_secrets" {
  name = "AmazonEKSFlaskAppSecretsCSIPolicy"

  policy = templatefile("${path.module}/iam/AmazonEKSFlaskAppSecretsCSIPolicy.json", {
    secret_arn = data.aws_secretsmanager_secret.flask_app_secret.arn
  })
}

resource "aws_iam_role_policy_attachment" "flask_app_secrets" {
  role       = aws_iam_role.flask_app_secrets.name
  policy_arn = aws_iam_policy.flask_app_secrets.arn
}

resource "aws_eks_pod_identity_association" "flask_app_secrets" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "flask-ns"
  service_account = "flask-app-sa"
  role_arn        = aws_iam_role.flask_app_secrets.arn
}
