#!/usr/bin/env bash

## install.sh is a script that installs selected helm chart deployment

# Fixed variables
SEPERATOR="----------------------------------------"
HELM_CHARTS_PATH=~/Universe/unii-helm-charts/charts
HELM_VALUES_PATH=~/Universe/unii-helm-charts/helm-values

# Fetch chart names and prompt user to select project to deploy
echo -e "$SEPERATOR"
echo -e $(ls $HELM_CHARTS_PATH) | tr ' ' '\n'
echo "Project: "
read project
# Check if project exists
if [[ ! $(ls $HELM_CHARTS_PATH/$project) ]]; then
  exit 1
fi

# Prompt user for deployment name
echo -e "$SEPERATOR"
echo "Release Name: "
read release

# Prompt user for kube context
echo -e "$SEPERATOR"
echo -e "$(kubectl config get-contexts | tail -n +2 | awk -F '[[:space:]]' '!$1{ $1="NA" }1' | awk '{print $2}')"
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

# Determine secrets path if it exists
echo -e "$SEPERATOR"
helm secrets clean $HELM_VALUES_PATH;
if [[ $(ls $HELM_VALUES_PATH/$project | grep "secrets.yaml") ]]; then
  helm secrets dec $HELM_VALUES_PATH/$project/"secrets.yaml"
  secrets_path=$HELM_VALUES_PATH/$project/secrets.yaml.dec
elif [[ $(ls $HELM_VALUES_PATH/$project/$context | grep "secrets.yaml") ]]; then
  helm secrets dec $HELM_VALUES_PATH/$project/$context/secrets.yaml
  secrets_path=$HELM_VALUES_PATH/$project/$context/secrets.yaml.dec
else
  echo -e "There is no secrets for this project"
fi

# Determine overwrite helm-values path if it exists
echo -e "$SEPERATOR"
if [[ $(ls $HELM_VALUES_PATH/$project/$context | grep "values.yaml") ]]; then
  overwrite_values_path=$HELM_VALUES_PATH/$project/$context/values.yaml
else
  echo -e "There is no overwrite values for this project"
fi

# Start helm install to deploy project with specified arguments
echo -e "$SEPERATOR"
echo -e "Starting Helm install"
args=(
  --name $release
  --kube-context $context
  --namespace $namespace
  --set env=$context
  --set image.tag=$sha
)
if [[ ! -z $secrets_path ]]; then
  echo -e "SECRETS PATH: $secrets_path"
  args+=(-f $secrets_path)
fi

if [[ ! -z $overwrite_values_path ]]; then
  echo -e "VALUES PATH: $overwrite_values_path"
  args+=(-f $overwrite_values_path)
fi

helm install $HELM_CHARTS_PATH/$project ${args[@]}
