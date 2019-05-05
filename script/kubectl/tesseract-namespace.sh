#!/bin/bash

# Fixed Deployment / Namespaces
# fixed=("default" "kube-system" "nginx-ingress" "sentry" "flux" "jmeter" "sqlproxy" "tesseract-v2")
fixed=(default kube-system kube-public nginx-ingress sentry flux jemalloc jmeter sqlproxy tesseract-v2 tesseract-volumesnapshots)
pattern=$(echo ${fixed[@]}|tr " " "|")

kubectl get namespaces | tail -n +2 | awk '{print $1}' | grep -Ev $pattern