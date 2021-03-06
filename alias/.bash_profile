# ----------------------
# Useful Hack Alias
# ----------------------
alias chrome='/opt/google/chrome/chrome'
alias edit-bp='code ~/.bash_profile'
# alias fuck='lsof -i tcp:4567 -i tcp:1979 -i tcp:1234 -i tcp:4888 -i tcp:4200 -i tcp:4201 -i tcp:1080 -i tcp:1025 -i tcp:6379 -i tcp:5432 -i tcp:8085 -i tcp:27017 | tr -s ' ' | tail -n+2 | cut -d' ' -f 2 | xargs kill'
alias halt='sudo /sbin/halt'
alias poweroff='sudo /sbin/poweroff'
alias reboot='sudo /sbin/reboot'
alias shutdown='sudo /sbin/shutdown'
alias passgen='openssl rand -base64'

# ----------------------
# Sysadmin - Alias
# ----------------------
alias kernel='uname -a'
alias ds='df -h'
alias dsd='du -sh'
alias cpu='l'
alias lc='launchctl'
alias top='htop'

# ----------------------
# Network - Alias
# ----------------------
alias ping='ping -c 5'
alias speed='speedtest-cli --server 2406 --simple'
alias ipe='curl ipinfo.io/ip'
alias ipi='ipconfig getifaddr en0'

# ----------------------
# General Commands
# ----------------------
# ls
alias ls='ls -FG'
alias lt='du -sh * | sort -h'
alias left='ls -t -l'

# cd
alias .....='cd ../../../../'
alias ....='cd ../../../../'
alias ...='cd ../../../'
alias ..='cd ..'

# diff
alias diff='colordiff'

# time
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%y"'
alias nowtime=now

# rm
alias rm="rm -v"
alias rmd="rm -rfv"

# grep
alias grep='grep --color=auto'

# browser
chrome() {
  /usr/bin/open -a "/Applications/Google Chrome.app" --args 'http://google.com/'
}

# mkdir + cd
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# bash command history grep
alias hg='history|grep'

# Count files in current dir
alias count='find . -type f | wc -l'

# Files
alias untar='tar -zxvf'
alias wget='wget -c'

# ----------------------
# General Functions
# ----------------------
service-console() {
  if [[ "$1" == "discover" ]]; then
    if [[ -z "$2" ]]; then
      echo "Please enter a namespace"
    elif [[ "$2" == "staging" ]]; then
      pod=$(kubectl --context staging get pods | grep -oE "discover-[a-zA-Z0-9]{1,}-[a-zA-Z0-9]{5}\b" | head -1)
      kubectl --context staging exec $pod -it -- bash -il
    elif [[ "$2" == "production" ]]; then
      pod=$(kubectl --context production get pods | grep -oE "discover-[a-zA-Z0-9]{1,}-[a-zA-Z0-9]{5}\b" | head -1)
      kubectl --context production exec $pod -it -- bash -il
    else
      local pod=$(kubectl --context staging --namespace $2 get pods | grep -oE "$2-discover-[a-zA-Z0-9]{1,}-[a-zA-Z0-9]{5}\b" | head -1)
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
      local pod=$(kubectl --context staging --namespace $2 get pods | grep -oE "$2-web-api-[a-zA-Z0-9]{1,}-[a-zA-Z0-9]{5}\b")
      kubectl --context staging --namespace $2 exec $pod -it -- bash -il
    fi
  elif [[ "$1" == "boxoffice" ]]; then
    if [[ -z "$2" ]]; then
      echo "Please enter a namespace"
    elif [[ "$2" == "staging" ]]; then
      pod=$(kubectl --context staging get pods | grep -oE "boxoffice-[a-zA-Z0-9]{1,}-[a-zA-Z0-9]{5}\b" | head -1)
      kubectl --context staging exec $pod -it -- bash -il
    elif [[ "$2" == "production" ]]; then
      pod=$(kubectl --context production get pods | grep -oE "boxoffice-[a-zA-Z0-9]{1,}-[a-zA-Z0-9]{5}\b" | head -1)
      kubectl --context production exec $pod -it -- bash -il
    else
      local pod=$(kubectl --context staging --namespace $2 get pods | grep -oE "$2-boxoffice-[a-zA-Z0-9]{1,}-[a-zA-Z0-9]{5}\b" | head -1)
      kubectl --context staging --namespace $2 exec $pod -it -- bash -il
    fi
  else
    echo "Please enter a service: web / boxoffice / discover"
  fi
}

# ----------------------
# Git - Alias
# ----------------------
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add --all'
alias gau='git add --update'
alias gb='git branch'
alias gbd='git branch --delete '
alias gc='git commit'
alias gcf='git commit --fixup'
alias gcm='git commit --message'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcod='git checkout develop'
alias gcom='git checkout master'
alias gcos='git checkout staging'
alias gd='git diff'
alias gda='git diff HEAD'
alias gf='git fetch'
alias gi='git init'
alias gld='git log --pretty=format:"%h %ad %s" --date=short --all'
alias glg='git log --graph --oneline --decorate --all'
alias gm='git merge --no-ff'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gp='git pull'
alias gpr='git pull --rebase'
alias gpush='git push'
alias gpushf='git push --force'
alias gr='git rebase'
alias gri='git rebase -i'
alias gs='git status'
alias gss='git status --short'
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash save'

# ----------------------
# Git - Functions
# ----------------------
gbdd() {
  git branch -D $1 && \
  git push origin --delete $1
}

gbclean() {
  git branch -r --merged origin/master | \
  grep origin | \
  grep -v '>' | \
  grep -v master | \
  xargs -L1 | \
  cut -d "/" -f2- | \
  xargs git push origin --delete
}

# ------------------------------
# Bundle (Ruby)
# ------------------------------
alias b='bundle'
alias be='bundle exec'
alias ber-db-m='bundle exec rake db:migrate'
alias ber='bundle exec rails'
alias berc='bundle exec rails c'
alias berg-m='bundle exec rails g migration'

# ------------------------------
# Kubectl (Kubernetes) - Alias
# ------------------------------
alias k='kubectl'
alias kcctxt='kubectl config current-context'
alias kconfig='kubectl config view'
alias kd='kubectl delete'
alias kdd='kubectl delete deployments'
alias kdes='kubectl describe'
alias kdesd='kubectl describe deployments'
alias kdeshr='kubectl describe helmrelease'
alias kdesi='kubectl describe ingress'
alias kdesp='kubectl describe pod'
alias kdess='kubectl describe service'
alias kdhr='kubectl delete helmreleases'
alias kdn='kubectl delete namespaces'
alias kdp='kubectl delete pod'
alias kds='kubectl delete service'
alias kdssec='kubectl delete sealedsecrets'
alias kg='kubectl get'
alias kgctxt='kubectl config get-contexts'
alias kgd='kubectl get deployment'
alias kghr='kubectl get helmreleases'
alias kgi='kubectl get ingress'
alias kgn='kubectl get namespaces'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgssec='kubectl get sealedsecrets'
alias kgvs='kubectl get volumesnapshots'
alias kge='kubectl get events'
alias kuctxt='kubectl config use-context'
alias kw='watch kubectl get pods --namespace'
alias ktn='kubectl top nodes'
alias kpf='kubectl port-forward'

# ------------------------------
# Kubectl (Kubernetes) - Functions
# ------------------------------
kssh() {
  pod=$(kubectl get pod -n $1 | grep -oE "$2-[a-zA-Z0-9]{1,}-[a-zA-Z0-9]{5}\b" | awk '{print $1}')
  kubectl --namespace $1 exec -it $pod /bin/bash
}

klog() {
  if [[ $# -lt 2 ]]; then
    pod=$(kubectl get --all-namespace pods | grep -oE "$1-[a-zA-Z0-9]{1,}-[a-zA-Z0-9]{5}\b" | head -1)
    kubectl logs $pod
  elif [[ $# -eq 2 ]]; then
    pod=$(kubectl get pods -n $1 | grep -oE "$2-[a-zA-Z0-9]{1,}-[a-zA-Z0-9]{5}\b" | head -1)
    kubectl logs -n $1 $pod
  fi
}

ktesseract() {
  pod=$(kubectl --context staging -n tesseract-v2 get pods | grep -oE "tesseract-v2-[a-zA-Z0-9]{1,}-[a-zA-Z0-9]{5}\b" | head -1 )
  kubectl --context staging --namespace tesseract-v2 exec -it $pod /bin/bash
}

kgss() {
  kubectl --namespace $1 get secrets $2 -ojsonpath="{.data.values\.yaml}" | \
    base64 --decode | \
    bat -l yaml
}

# ----------------------
# Helm - Alias
# ----------------------
alias helm-d="helm delete --purge"
alias helm-h="helm history --max 10"
alias helm-l="helm list --max"
alias helm-prod="helm --kube-context production"
alias helm-rb="helm rollback"
alias helm-staging="helm --kube-context staging"

# ----------------------
# Helm Secrets - Alias
# ----------------------
alias helm-s-clean="helm secrets clean"
alias helm-s-dec="helm secrets dec"
alias helm-s-edit="helm secrets edit"
alias helm-s-enc="helm secrets enc"

# ----------------------
# Gcloud - Alias
# ----------------------
alias gcl='gcloud'
alias gcl-c-create='gcloud container clusters create '
alias gcl-c-delete='gcloud container clusters delete '
alias gcl-c-info='gcloud container clusters describe '
alias gcl-d-p="gcloud docker -- push"
alias gcl-g-i='gcloud compute instances list'
alias gcl-kms='gcloud kms'
alias gcl-dns='gcloud dns'
alias gcl-dns-mz='gcloud dns managed-zones'
alias gcl-dns-rs='gcloud dns record-sets'
alias gcl-comp='gcloud compute'
alias gcl-comp-ins='gcloud compute instances'
alias gcl-update='gcloud components update --quiet'

# ----------------------
# Gcloud - Functions
# ----------------------
gclkmskr() {
  gcloud kms keyrings list \
    --location global
}

gclkmskc() {
  gcloud kms keyrings create $2 \
    --location global \
    --project $1 &&
  glcoud kms keys create $3 \
    --location global \
    --project $1 \
    --keyring $2 \
    --purpose encryption
}

gcl-ctxt-legacy() {
  gcloud config set project verticalscope-production && \
  gcloud container clusters get-credentials -z us-central1-b web-p0
}

gcl-ctxt-cali() {
  gcloud config set project california-production && \
  gcloud container clusters get-credentials -z us-central1-b prod
}

# ----------------------
# Fluxctl - Alias
# ----------------------
alias flux-l-i='fluxctl list images'
alias flux-l-w='fluxctl list workloads'
alias flux-r='fluxctl release'
alias flux-s='fluxctl sync'
alias flux='fluxctl'

# ----------------------
# Fluxctl - Functions
# ----------------------
flux-list-hr() {
  fluxctl list-images --namespace $1 --workload=$1:helmrelease/$2
}

flux-upgrade() {
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
# Docker - Alias
# ----------------------
alias dk='docker'
alias dki='docker images'
alias dkkill='docker kill'
alias dkps='docker ps'
alias dkpull='docker pull'
alias dkpush='docker push'
alias dkrm='docker rm'
alias dkrmi='docker rmi'
alias dkrun='docker run'
alias dks='docker services'
alias dktag='docker tag'
alias dkv='docker version'
alias dkb='docker build'

# ----------------------
# Docker - Function
# ----------------------
dkcleani() { docker rmi -f $(docker images -a -q); }
dkcleanc() { docker rm -f $(docker ps -a -q); }
dk-run() { docker run -it $1 /bin/bash; }
dk-exec() { docker exec -it $1 /bin/bash; }

dkclean() {
  docker rmi -f $(docker images -a -q) && \
  docker rm -f $(docker ps -a -q)
}

# Docker Pubilsh: build => tag => push
# Params:  dkpublish <Dockerfile-Path> <repo:tag> <build-context-dir>
dkpublish() {
  docker build $3 \
    -f $1 \
    -t $2 && \
  docker push $2
}

# Arg: dkbuild <Dockerfile> <tag> <dir>
dkbuild() {
  docker build \
    -f $1 \
    -t $2 \
    $3
}

# ----------------------
# Terraform - Alias
# ----------------------
alias tf='terraform'
alias tfa='terraform apply'
alias tfs='terraform show'
alias tfd='terraform destroy'
alias tfc='terraform console'
alias tff='terraform fmt'
alias tfg='terraform graph'
alias tfim='terraform import'
alias tfin='terraform init'
alias tfo='terraform output'
alias tfp='terraform plan'

# ----------------------
# Gatsby - Alias
# ----------------------
alias gat='gatsby'
alias gat-dev='gatsby develop'
alias gat-s='gatsby serve'

# ----------------------
# PATHS
# ----------------------
# GOLANG
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"
export GOENV_VERSION=1.15.3
