#!/bin/bash

if [[ -z "$1" ]]; then
  echo "Please enter valid project"
elif [[ "$1" == "web" ]]; then
  if [[ "$2" == "staging" ]]; then
    echo "Running $1 staging console"
    cd ~/Universe/devops
    ./attach.sh web staging bundle exec rails c
  elif [[ "$2" == "production" ]]; then
    echo "Running $1 production console"
    cd ~/Universe/devops
    ./attach.sh web production bundle exec rails c
  else
    echo "Running $1 $2 console"
    pod=$(kubectl --context staging --namespace $2 get pods | grep -o "$2-web-api-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+")
    kubectl --context staging --namespace $2 exec $pod -it -- bash -il
  fi
elif [[ "$1" == "bo" ]]; then
  if [[ "$2" == "staging" ]]; then
    echo "Running $1 staging console"
    pod=$(kubectl --context staging get pods | grep -o "boxoffice-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+" | head -1)
    kubectl --context staging exec $pod -it -- bash -il
  elif [[ "$2" == "production" ]]; then
    echo "Running $1 production console"
    pod=$(kubectl --context production get pods | grep -o "boxoffice-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+" | head -1)
    kubectl --context staging exec $pod -it -- bash -il
  else
    echo "Running $1 $2 env console"
    pod=$(kubectl --context staging --namespace $2 get pods | grep -o "$2-boxoffice-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+" | head -1)
    kubectl --context staging --namespace $1 exec $pod -it -- bash -il
  fi
fi