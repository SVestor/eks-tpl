#!/bin/bash

aws eks update-kubeconfig \
  --profile aws-general \
  --region us-east-1 \
  --alias aws-general@core-eks-dev \
  --name core-eks-dev

kubectl apply -f ../awsLBcontroller_alb/
