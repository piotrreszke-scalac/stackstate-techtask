#!/bin/bash
set -euo pipefail

DIR="$(dirname "$BASH_SOURCE")"
export KUBECONFIG=${DIR}/../infra/kubeconfig

[ -d ${DIR}/charts ] || helm dependency build

helm template  --release-name metrics-server -f values.yml -n kube-system --include-crds . > manifest.yml
kubectl -n kube-system apply -f manifest.yml
