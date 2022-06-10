#!/usr/bin/env bash

# Run e2e tests

set -o errexit

#  --subnets="subnet-05d6d6c02cacf4474,subnet-0c1a3896519b2dcf0,subnet-046596eb985492dfb" \


kops create cluster --name=k8s-arm64-cluster.k8s.local \
  --state=s3://cz-kops-base \
  --cloud=aws \
  --vpc=vpc-025b719d2466e3193 \
  --zones="us-east-1a,us-east-1b,us-east-1c" \
  --image=ami-0484689eedbc6b6f1 \
  --master-count=3 \
  --master-size=m6g.2xlarge \
  --node-count=3 \
  --node-size=m6g.xlarge \
  --container-runtime=containerd \
  --kubernetes-version="1.22" \
  --authorization=RBAC \
  --networking=amazonvpc \
  --dry-run \
  -oyaml > erase-arm64.yaml

