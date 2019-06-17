#!/usr/bin/env bash

## install.sh is a script that installs selected helm chart deployment

# Fixed variables
SEPERATOR="----------------------------------------"

# Fetch chart names and prompt user to select project to deploy
echo -e "$SEPERATOR"
echo -e "$(ls ~/Universe/unii-helm-charts/charts)"
echo "Project: "
read project

# Prompt user for deployment name
echo -e "$SEPERATOR"
echo "Release Name: "
read release

# Prompt user for kube context
echo -e "$SEPERATOR"
echo -e "$(kubectl config get-contexts | tail -n +2 | awk '{print $2}')"
echo "Context: "
read context

# Prompt user for namespace
echo -e "$SEPERATOR"
echo "Namespace: "
read namespace

# Prompt user for sha of project to deploy
echo -e "$SEPERATOR"
echo "Project sha: "
read sha

# Start helm install to deploy project with specified arguments
echo -e "$SEPERATOR"
echo -e "Starting Helm install"
helm secrets clean ~/Universe/unii-helm-charts/helm-values/"$project";
if [[ $(ls ~/Universe/unii-helm-charts/helm-values/$project | grep "secrets.yaml") ]]; then
  helm secrets dec ~/Universe/unii-helm-charts/helm-values/"$project"/secrets.yaml;
  helm install ~/Universe/unii-helm-charts/charts/"$project" \
    --name "$release" \
    --kube-context "$context" \
    --namespace "$namespace" \
    --set env="$context" \
    -f ~/Universe/unii-helm-charts/helm-values/"$project"/secrets.yaml.dec \
    -f ~/Universe/unii-helm-charts/helm-values/"$project"/values.yaml \
    --set image.tag="$sha"
elif [[ $(ls ~/Universe/unii-helm-charts/helm-values/$project/$context | grep "secrets.yaml") ]]; then
  helm secrets dec ~/Universe/unii-helm-charts/helm-values/"$project"/"$context"/secrets.yaml;
  helm install ~/Universe/unii-helm-charts/charts/"$project" \
    --name "$release" \
    --kube-context "$context" \
    --namespace "$namespace" \
    --set env="$context" \
    -f ~/Universe/unii-helm-charts/helm-values/"$project"/"$context"/secrets.yaml.dec \
    -f ~/Universe/unii-helm-charts/helm-values/"$project"/"$context"/values.yaml \
    --set image.tag="$sha"
fi
