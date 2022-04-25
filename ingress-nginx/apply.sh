#!/bin/bash
set -euo pipefail

DIR="$(dirname "$BASH_SOURCE")"
export KUBECONFIG=${DIR}/../infra/kubeconfig

kubectl apply -f ns.yml --server-side

helm dependency build
helm template  --release-name ingress-nginx -n ingress-nginx -f values.yml --include-crds . > manifest.yml
kubectl -n ingress-nginx apply -f manifest.yml
