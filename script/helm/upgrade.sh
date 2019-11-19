#!/usr/bin/env bash

## upgrade.sh is a script that installs selected helm chart deployment

# Fixed variables
SEPERATOR="----------------------------------------"
HELM_CHARTS_PATH=~/Universe/unii-helm-charts/charts
HELM_VALUES_PATH=~/Universe/unii-helm-charts/helm-values

# Prompt user for release Name
echo -e "$SEPERATOR"
echo "Enter Kubernetes release name: "
read release

# Prompt user for namespace
echo -e "$SEPERATOR"
echo "Enter Kubernetes namespace name: "
read namespace

if [[ ! $(kubectl get pods -n $namespace | grep $release) ]]; then
  echo -e "Kubernetes Release not found"
  exit 1
fi

# Fetch chart names and prompt user to select project to deploy
echo -e "$SEPERATOR"
echo -e $(ls $HELM_CHARTS_PATH) | tr ' ' '\n'
echo "Helm Chart: "
read chart

# Check if project exists
if [[ ! $(ls $HELM_CHARTS_PATH/$chart) ]]; then
  exit 1
fi

# Prompt user for kube context
echo -e "$SEPERATOR"
echo -e "$(kubectl config get-contexts | tail -n +2 | awk -F '[[:space:]]' '!$1{ $1="NA" }1' | awk '{print $2}')"
echo "Context: "
read context

# Prompt user for sha of project to deploy
echo -e "$SEPERATOR"
echo "Project sha: "
read sha

# Prompt user if they want to reuse values (secrets/values)
echo -e "$SEPERATOR"
echo "Reuse Values (helm secrets/values)? Y/N"
read is_new_values

# Fill out necessary arguments for helm upgrade command
args=(
  $release
  $HELM_CHARTS_PATH/$chart
  --kube-context $context
  --namespace $namespace
  --set env=$context
  --set image.tag=$sha
)

if [[ $is_new_values == "Y" ]]; then
  echo -e "$SEPERATOR"
  echo -e "Reusing Values from last release"
  args+=(--reuse-values)
elif [[ $is_new_values == "N" ]]; then
  # Determine secrets path if it exists
  echo -e "$SEPERATOR"
  echo -e "Updating Values"
  helm secrets clean $HELM_VALUES_PATH;
  if [[ $(ls $HELM_VALUES_PATH/$chart | grep "secrets.yaml") ]]; then
    helm secrets dec $HELM_VALUES_PATH/$chart/"secrets.yaml"
    secrets_path=$HELM_VALUES_PATH/$chart/secrets.yaml.dec
  elif [[ $(ls $HELM_VALUES_PATH/$chart/$context | grep "secrets.yaml") ]]; then
    helm secrets dec $HELM_VALUES_PATH/$chart/$context/secrets.yaml
    secrets_path=$HELM_VALUES_PATH/$chart/$context/secrets.yaml.dec
  else
    echo -e "There is no secrets for this project"
  fi

  # Determine overwrite helm-values path if it exists
  echo -e "$SEPERATOR"
  if [[ $(ls $HELM_VALUES_PATH/$chart | grep "values.yaml") ]]; then
    overwrite_values_path=$HELM_VALUES_PATH/$chart/values.yaml
  elif [[ $(ls $HELM_VALUES_PATH/$chart/$context | grep "values.yaml") ]]; then
    overwrite_values_path=$HELM_VALUES_PATH/$chart/$context/values.yaml
  else
    echo -e "There is no overwrite values for this project"
  fi

  if [[ ! -z $secrets_path ]]; then
    echo -e "SECRETS PATH: $secrets_path"
    args+=(-f $secrets_path)
  fi

  if [[ ! -z $overwrite_values_path ]]; then
    echo -e "VALUES PATH: $overwrite_values_path"
    args+=(-f $overwrite_values_path)
  fi
fi

# Start helm install to deploy project with specified arguments
echo -e "$SEPERATOR"
echo -e "Starting Helm Upgrade"
helm upgrade ${args[@]}
