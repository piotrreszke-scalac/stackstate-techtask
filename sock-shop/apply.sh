#!/bin/bash
set -euo pipefail

DIR="$(dirname "$BASH_SOURCE")"
curl -o ${DIR}/complete-demo.yaml https://raw.githubusercontent.com/microservices-demo/microservices-demo/5193b1eeb310a2abdefc1a3786d0666ca7d4324b/deploy/kubernetes/complete-demo.yaml

export KUBECONFIG=${DIR}/../infra/kubeconfig

kubectl apply -f ${DIR}/complete-demo.yaml
