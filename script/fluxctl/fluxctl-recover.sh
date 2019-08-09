#!/usr/bin/env bash

# Used cli check
if ! command -v kubectl > /dev/null; then
  echo "'kubectl' is not installed" >&2 && \
  exit 1
fi

if ! command -v helm > /dev/null; then
  echo "'helm' is not installed" >&2 && \
  exit 1
fi

if ! command -v fluxctl > /dev/null; then
  echo "'fluxctl' is not installed" >&2 && \
  exit 1
fi

# Determine helmrelease name which is in failing state
prefix="default\:helmrelease\/"
helm_release=$(flux-l-w | grep PENDING_UPGRADE | awk 'NR==1{print $1}' | sed -e "s/^$prefix//")

# Determine if helmrelease exists under helm
if [[ -z  $(helm list | awk '{print $1}' | grep -x "$helm_release") ]]; then
  echo -e "ERROR helm release doesn't exist"
  exit 1
fi

# Rollback to latest DEPLOYED version
failed_revision=$(helm history $helm_release | grep PENDING_UPGRADE | awk '{print $1}')
last_successful_revision=$(helm history $helm_release | grep DEPLOYED | awk -v failed_revision=$failed_revision '{
  if ($1 -lt $failed_revision)
    print $1
  else
    print "fail"
}' | tail -1 )
helm rollback $helm_release $last_successful_revision