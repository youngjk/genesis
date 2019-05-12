#!/bin/bash

SEPERATOR="----------------------------------------"

# name of helm chart/deployment
echo -e "$SEPERATOR"
echo -e "$(ls ~/Universe/unii-helm-charts/charts)"
echo -e "Project: "
read project

# name of release/deployment
echo -e "$SEPERATOR"
echo -e "Release Name: "
read release

# name of kube context/project
echo -e "$SEPERATOR"
echo -e "$(kubectl config get-contexts | tail -n +2 | awk '{print $2}')"
echo -e "Context:"
read context

# name of namespace
echo -e "$SEPERATOR"
echo -e "Namespace:"
read namespace

# sha of release/deployment
echo -e "$SEPERATOR"
echo -e "Project sha:"
read sha

echo -e "$SEPERATOR"
echo -e "Starting Helm install"
helm secrets clean ~/Universe/unii-helm-charts/helm-values/"$project";
if [[ $(ls ~/Universe/unii-helm-charts/helm-values/$project | grep "secrets.yaml") ]]; then
  helm secrets dec ~/Universe/unii-helm-charts/helm-values/"$project"/secrets.yaml;
  helm install ~/Universe/unii-helm-charts/charts/"$project" --name "$release" --kube-context "$context" --namespace "$namespace" --set env="$context" -f ~/Universe/unii-helm-charts/helm-values/"$project"/secrets.yaml.dec --set image.tag="$sha"
else
  helm secrets dec ~/Universe/unii-helm-charts/helm-values/"$project"/"$context"/secrets.yaml;
  helm install ~/Universe/unii-helm-charts/charts/"$project" --name "$release" --kube-context "$context" --namespace "$namespace" --set env="$context" -f ~/Universe/unii-helm-charts/helm-values/"$project"/"$context"/secrets.yaml.dec -f ~/Universe/unii-helm-charts/helm-values/"$project"/"$context"/values.yaml --set image.tag="$sha"
fi
