#!/bin/bash

DIR="$(dirname "$BASH_SOURCE")"
export KUBECONFIG=${DIR}/../infra/kubeconfig

find . -mindepth 2 | grep 'apply.sh$' | while read file
do
  pushd $(dirname $file)
  ./$(basename $file)
 popd
done
