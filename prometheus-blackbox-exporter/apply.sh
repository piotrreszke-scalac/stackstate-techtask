#!/bin/bash
set -euo pipefail

DIR="$(dirname "$BASH_SOURCE")"
export KUBECONFIG=${DIR}/../infra/kubeconfig

kubectl apply -f ns.yml --server-side

[ -d ${DIR}/charts ] || helm dependency build

helm template --release-name prometheus-blackbox-exporter -n prometheus-blackbox-exporter -f values.yml --include-crds . > manifest.yml
kubectl -n prometheus-blackbox-exporter  apply -f manifest.yml
kubectl -n prometheus-blackbox-exporter  apply -f probe.yml
kubectl -n prometheus-blackbox-exporter  apply -f rules.yml
