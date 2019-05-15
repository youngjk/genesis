#!/bin/bash

# This script is to clean up all orphaned helm releases

SEPERATOR="----------------------------------------"

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

# list of orphaned release namespaces
DESTROYED_NAMESPACES=()

# Compute list of orphaned release namespaces
for i in $HELM_NAMESPACES; do
  found=0
  for j in $KUBE_NAMESPACES; do
    [[ $i == $j ]] && found=1
  done
  [[ $found == 1 ]] || DESTROYED_NAMESPACES+=($i)
done

echo -e "$SEPERATOR"
echo -e "Orphaned Namespace with Releases:"
echo "${DESTROYED_NAMESPACES[@]}" | tr ' ' '\n'

echo -e "$SEPERATOR"
echo -e "Should we proceed with deleting orphaned releases? (Y/N)"
read proceed
# Purge delete orphaned releases
if [[ $proceed == "Y" ]]; then
  for i in ${DESTROYED_NAMESPACES[@]}; do
    helm delete --purge $(helm list -a -m 1000 --namespace $i | awk '{print $1}' | tail -n +2)
  done
fi
