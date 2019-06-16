#!/usr/bin/env bash

## kube-ssh is script used for sshing into various kube deployments

if ! command -v kubectl > /dev/null; then
  echo "'kubectl' is not installed" >&2 && \
  exit 1
fi

if [[ $# -lt 2 ]] || [[ $1 == "--help" ]] || [[ $1 == "-h" ]]; then
  echo "Usage: kube-ssh <namespace> <name>" >&2 && \
  exit 2
fi

pod=$(kubectl get pod --namespace $1 | grep -o "$2-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+ " | awk '{print $1}')
kubectl --namespace $1 exec -it $pod /bin/bash