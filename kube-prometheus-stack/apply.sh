#!/bin/bash
set -euo pipefail

DIR="$(dirname "$BASH_SOURCE")"
export KUBECONFIG=${DIR}/../infra/kubeconfig

kubectl -n monitoring apply -f basic.enc.yml --server-side
kubectl -n monitoring apply -f dashboards --server-side --recursive
kubectl -n monitoring apply -f prometheusrules --server-side --recursive

# Big CRDs have problem when being applied standard way (https://github.com/kubernetes/kubectl/issues/712), thus this workaround
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.55.0/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.55.0/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.55.0/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.55.0/example/prometheus-operator-crd/monitoring.coreos.com_probes.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.55.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.55.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.55.0/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.55.0/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml

kubectl apply -f ns.yml --server-side

[ -d ${DIR}/charts ] || helm dependency build

helm template  --release-name monitoring -f values.enc.yml -f values.yml -n monitoring --skip-crds . > manifest.yml
kubectl apply -f manifest.yml
