#!/bin/bash
set -euo pipefail

DIR="$(dirname "$BASH_SOURCE")"
export KUBECONFIG=${DIR}/../infra/kubeconfig

kubectl apply -f ns.yml

[ -d ${DIR}/charts ] || helm dependency build

helm template  -a monitoring.coreos.com/v1 --release-name prometheus-rabbitmq-exporter -n prometheus-rabbitmq-exporter -f values.yml --include-crds . > manifest.yml
kubectl -n prometheus-rabbitmq-exporter apply -f manifest.yml

kubectl -n sock-shop apply -f rabbitmq-service-http.yml
