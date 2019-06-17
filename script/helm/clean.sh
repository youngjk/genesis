#!/usr/bin/env bash

## clean.sh is a script that cleans up all orphaned helm releases

# Fixed variables
SEPERATOR="----------------------------------------"

# Used cli check
if ! command -v kubectl > /dev/null; then
  echo "'kubectl' is not installed" >&2 && \
  exit 1
fi

if ! command -v helm > /dev/null; then
  echo "'helm' is not installed" >&2 && \
  exit 1
fi

# Returns list of namespaces in kube-context
KUBE_NAMESPACES=$(kubectl get namespaces | tail -n +2 | awk '{print $1}')
echo -e "$SEPERATOR"
echo -e "Namespaces in current kube context:"
echo "${KUBE_NAMESPACES[@]}"

# Returns list of namespaces in helm list
HELM_NAMESPACES=$(helm list -a -m 1000 | tail -n +2 | awk '{print $10}' | awk '!a[$0]++')
echo -e "$SEPERATOR"
echo -e "Namespaces in helm list:"
echo "${HELM_NAMESPACES[@]}"

# Compute and return list of orphaned release namespaces
DESTROYED_NAMESPACES=()
for i in $HELM_NAMESPACES; do
  found=false
  for j in $KUBE_NAMESPACES; do
    [[ $i == $j ]] && found=true
  done
    [[ "$found" = true ]] || DESTROYED_NAMESPACES+=($i)
done

echo -e "$SEPERATOR"
echo -e "Orphaned Namespace with Releases:"
echo "${DESTROYED_NAMESPACES[@]}" | tr ' ' '\n'

# Prompt user whether to delete orphaned releases
echo -e "$SEPERATOR"
echo -e "Should we proceed with deleting orphaned releases? (Y\N)"
read proceed
# Purge delete orphaned releases
if [[ ${proceed,,} == "y" ]]; then
  for i in ${DESTROYED_NAMESPACES[@]}; do
    helm delete --purge $(helm list -a -m 1000 --namespace $i | awk '{print $1}' | tail -n +2)
  done
else
  echo -e "Exiting program"
fi
