#!/bin/bash
set -euo pipefail

DIR="$(dirname "$BASH_SOURCE")"
export KUBECONFIG=${DIR}/../infra/kubeconfig

kubectl apply -f ns.yml --server-side

[ -d ${DIR}/charts ] || helm dependency build

helm template  -a monitoring.coreos.com/v1 --release-name prometheus-redis-exporter -n prometheus-redis-exporter -f values.yml --include-crds . > manifest.yml
kubectl -n prometheus-redis-exporter  apply -f manifest.yml
