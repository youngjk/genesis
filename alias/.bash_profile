# ----------------------
# A. Useful Hack Alias
# ----------------------
alias edit-bp='code ~/.bash_profile'
alias fuck='lsof -i tcp:4567 -i tcp:1979 -i tcp:1234 -i tcp:4888 -i tcp:4200 -i tcp:4201 -i tcp:1080 -i tcp:1025 -i tcp:6379 -i tcp:5432 -i tcp:8085 -i tcp:27017 | tr -s ' ' | tail -n+2 | cut -d' ' -f 2 | xargs kill'
alias my-ip='curl http://ipecho.net/plain; echo'
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'
alias chrome='/opt/google/chrome/chrome'

# ----------------------
# B-1. General Commands
# ----------------------
# ls
alias ls='ls -FG'
alias ll='ls -la'
alias l.='ls -d .* -G'

# cd
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'

# diff
alias diff='colordiff'

# time
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%y"'

# rm
alias rm="rm -v"
alias rmd="rm -rfv"

# browser
chrome() {
  /usr/bin/open -a "/Applications/Google Chrome.app" --args 'http://google.com/'
}

# mkdir + cd
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# ----------------------
# B-2. General Functions
# ----------------------
service-console() {
  if [[ "$1" == "discover" ]]; then
    if [[ -z "$2" ]]; then
      echo "Please enter a namespace"
    elif [[ "$2" == "staging" ]]; then
      pod=$(kubectl --context staging get pods | grep -o "discover-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+" | head -1)
      kubectl --context staging exec $pod -it -- bash -il
    elif [[ "$2" == "production" ]]; then
      pod=$(kubectl --context production get pods | grep -o "discover-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+" | head -1)
      kubectl --context production exec $pod -it -- bash -il
    else
      local pod=$(kubectl --context staging --namespace $2 get pods | grep -o "$2-discover-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+" | head -1)
      kubectl --context staging --namespace $2 exec $pod -it -- bash -il
    fi
  elif [[ "$1" == "web" ]]; then
    if [[ -z "$2" ]]; then
      echo "Please enter a namespace"
    elif [[ "$2" == "staging" ]]; then
      cd ~/Universe/devops
      ./attach.sh web staging bundle exec rails c
      cd -
    elif [[ "$2" == "production" ]]; then
      cd ~/Universe/devops
      ./attach.sh web production bundle exec rails c
      cd -
    else
      local pod=$(kubectl --context staging --namespace $2 get pods | grep -o "$2-web-api-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+")
      kubectl --context staging --namespace $2 exec $pod -it -- bash -il
    fi
  elif [[ "$1" == "boxoffice" ]]; then
    if [[ -z "$2" ]]; then
      echo "Please enter a namespace"
    elif [[ "$2" == "staging" ]]; then
      pod=$(kubectl --context staging get pods | grep -o "boxoffice-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+" | head -1)
      kubectl --context staging exec $pod -it -- bash -il
    elif [[ "$2" == "production" ]]; then
      pod=$(kubectl --context production get pods | grep -o "boxoffice-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+" | head -1)
      kubectl --context production exec $pod -it -- bash -il
    else
      local pod=$(kubectl --context staging --namespace $2 get pods | grep -o "$2-boxoffice-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+" | head -1)
      kubectl --context staging --namespace $2 exec $pod -it -- bash -il
    fi
  else
    echo "Please enter a service: web / boxoffice / discover"
  fi
}

# ----------------------
# C-1. Git - Alias
# ----------------------
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add --all'
alias gau='git add --update'
alias gb='git branch'
alias gbd='git branch --delete '
alias gc='git commit'
alias gcm='git commit --message'
alias gcf='git commit --fixup'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout master'
alias gcos='git checkout staging'
alias gcod='git checkout develop'
alias gd='git diff'
alias gda='git diff HEAD'
alias gi='git init'
alias glg='git log --graph --oneline --decorate --all'
alias gld='git log --pretty=format:"%h %ad %s" --date=short --all'
alias gm='git merge --no-ff'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gp='git pull'
alias gpush='git push'
alias gpr='git pull --rebase'
alias gr='git rebase'
alias gs='git status'
alias gss='git status --short'
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash save'
alias gf='git fetch'

# ----------------------
# C-2. Git - Functions
# ----------------------
gbdd() {
  git branch -D $1 && \
  git push origin --delete $1
}

# ------------------------------
# D. Bundle (Ruby)
# ------------------------------
alias b='bundle'
alias be='bundle exec'
alias ber='bundle exec rails'
alias berc='bundle exec rails c'
alias berg-m='bundle exec rails g migration'
alias ber-db-m='bundle exec rake db:migrate'

# ------------------------------
# E-1. Kubectl (Kubernetes) - Alias
# ------------------------------
alias k='kubectl'
alias kconfig='kubectl config view'
alias kgctxt='kubectl config get-contexts'
alias kcctxt='kubectl config current-context'
alias kuctxt='kubectl config use-context'
alias kg='kubectl get'
alias kgs='kubectl get services'
alias kgp='kubectl get pods'
alias kgd='kubectl get deployment'
alias kgn='kubectl get namespaces'
alias kgvs='kubectl get volumesnapshots'
alias kghr='kubectl get helmreleases'
alias kgssec='kubectl get sealedsecrets'
alias kd='kubectl delete'
alias kds='kubectl delete service'
alias kdp='kubectl delete pod'
alias kdn='kubectl delete namespaces'
alias kdd='kubectl delete deployments'
alias kdhr='kubectl delete helmreleases'
alias kdssec='kubectl delete sealedsecrets'
alias kw='watch kubectl get pods --namespace'

# ------------------------------
# E-2. Kubectl (Kubernetes) - Functions
# ------------------------------
kssh() {
  pod=$(kubectl get pod --namespace $1 | grep -o "$2-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+" | awk '{print $1}')
  kubectl --namespace $1 exec -it $pod /bin/bash
}

klog() {
  if [[ $# -lt 2 ]]; then
    pod=$(kubectl get --all-namespace pods | grep -o "$1-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+ " | head -1)
    kubectl logs $pod
  elif [[ $# -eq 2 ]]; then
    pod=$(kubectl get pods -n $1 | grep -o "$2-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+ " | head -1)
    kubectl logs -n $1 $pod
  fi
}

ktesseract() {
  if [[ -z "$1" ]]; then
    echo "Please enter tesseract version"
  elif [[ "$1" == "v1" ]]; then
    pod=$(kubectl --context staging --namespace default get pods | grep -o "tesseract-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+" | head -1 )
    kubectl --context staging --namespace default exec -it $pod /bin/bash
  elif [[ "$1" == "v2" ]]; then
    pod=$(kubectl --context staging --namespace tesseract-v2 get pods | grep -o "tesseract-v2-[a-zA-Z0-9]\+-[a-zA-Z0-9]\+" | head -1 )
    kubectl --context staging --namespace tesseract-v2 exec -it $pod /bin/bash
  fi
}

kgss() {
  kubectl --namespace $1 get secrets $2 -ojsonpath="{.data.values\.yaml}" | \
    base64 --decode | \
    bat -l yaml
}

# ----------------------
# F-1. Helm - Alias
# ----------------------
alias helm-prod="helm --kube-context production"
alias helm-staging="helm --kube-context staging"
alias helm-d="helm delete --purge"
alias helm-l="helm list --max"
alias helm-h="helm history --max 10"
alias helm-rb="helm rollback"

# ----------------------
# F-2. Helm Secrets - Alias
# ----------------------
alias helm-s-clean="helm secrets clean"
alias helm-s-dec="helm secrets dec"
alias helm-s-enc="helm secrets enc"
alias helm-s-edit="helm secrets edit"

# ----------------------
# G. Gcloud - Alias
# ----------------------
alias gcl 'gcloud'
alias gcl-prod='gcloud container clusters get-credentials unii-prod-east --zone us-east4-a --project striped-buckeye-163915'
alias gcl-staging='gcloud container clusters get-credentials unii-staging --zone us-east4-a --project unii-staging'
alias gcl-c-delete='gcloud container clusters delete '
alias gcl-c-create='gcloud container clusters create '
alias gcl-c-info='gcloud container clusters describe '
alias gcl-g-i='gcloud compute instances list'
alias gcl-d-p="gcloud docker -- push"

# ----------------------
# H-1. Fluxctl - Alias
# ----------------------
alias flux='fluxctl'
alias flux-l-w='fluxctl list workloads'
alias flux-l-i='fluxctl list images'
alias flux-s='fluxctl sync'
alias flux-r='fluxctl release'

# ----------------------
# H-2. Fluxctl - Functions
# ----------------------
function flux-list-hr() {
  fluxctl list-images --namespace $1 --workload=$1:helmrelease/$2
}

function flux-upgrade() {
  version=0.11.0

  if [[ $# -ge 2 ]]; then
    version=$2
  fi

  helm upgrade flux \
    --namespace flux \
    --recreate-pods \
    --version $version \
    -f ~/Universe/unii-helm-charts/flux/values.yaml \
    -f ~/Universe/unii-helm-charts/flux/$1.yaml \
    fluxcd/flux
}

# ----------------------
# I-1. Docker - Alias
# ----------------------
alias dk='docker'
alias dkv='docker version'
alias dkps='docker ps'
alias dkpush='docker push'
alias dkpull='docker pull'
alias dktag='docker tag'
alias dkkill='docker kill'
alias dkrm='docker rm'
alias dkrmi='docker rmi'
alias dkrun='docker run'
alias dki='docker images'
alias dks='docker services'

# ----------------------
# I-2. Docker - Function
# ----------------------
dkcleani() { docker rmi -f $(docker images -a -q); }
dkcleanc() { docker rm -f $(docker ps -a -q); }
dk-run() { docker run -it $1 /bin/bash; }
dk-exec() { docker exec -it $1 /bin/bash; }

dkclean() {
  docker rmi -f $(docker images -a -q) && \
  docker rm -f $(docker ps -a -q)
}
