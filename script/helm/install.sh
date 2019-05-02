#!/bin/bash

# name of helm chart/deployment
echo -e "$(ls ~/Universe/unii-helm-charts/charts)"
echo -e "Project: "
read project

# name of release/deployment
echo -e "Release Name: "
read release

# name of kube context/project
echo -e "$(kubectl config get-contexts | tail -n +2 | awk '{print $2}')"
echo -e "Context:"
read context

# name of namespace
echo -e "Namespace:"
read namespace

# sha of release/deployment
echo -e "Project sha:"
read sha

helm secrets clean ~/Universe/unii-helm-charts/helm-values/"$project";
helm secrets dec ~/Universe/unii-helm-charts/helm-values/"$project"/secrets.yaml;
helm install ~/Universe/unii-helm-charts/charts/"$project" --name "$release" --kube-context "$context" --namespace "$namespace" --set env="$context" -f ~/Universe/unii-helm-charts/helm-values/"$project"/secrets.yaml.dec --set image.tag="$sha"
