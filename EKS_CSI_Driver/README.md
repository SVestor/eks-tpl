## EKS CSI Driver

### To show available addons

```bash
aws eks describe-addon-versions \
  --region us-east-1 \
  --profile cloud-user \
  --kubernetes-version 1.31 |  grep -i AddonName | grep csi
```

```bash
eksctl utils describe-addon-versions --kubernetes-version 1.31 --profile=cloud-user | grep AddonName | grep csi
```

### To show available versions of EKS CSI plugin

```bash
eksctl utils describe-addon-versions --kubernetes-version 1.31 --name aws-ebs-csi-driver --profile cloud-user | grep AddonVersion
```

```bash
aws eks describe-addon-versions \
  --region us-east-1 \
  --profile cloud-user \
  --kubernetes-version 1.31 \
  --addon-name aws-ebs-csi-driver | grep -i AddonVersion
```

