#!/bin/bash
set -euo pipefail

DIR="$(dirname "$BASH_SOURCE")"
export KUBECONFIG=${DIR}/../infra/kubeconfig

kubectl -n kube-system get cm kube-proxy-config -o yaml | sed 's#127.0.0.1:10249#0.0.0.0:10249#' | kubectl apply -f -
kubectl -n kube-system rollout restart ds kube-proxy
