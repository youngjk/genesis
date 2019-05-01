# ----------------------
# Useful Hack Alias
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
# General Commands
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
# Git
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

# ------------------------------
# bundle (Ruby)
# ------------------------------
alias b='bundle'
alias be='bundle exec'
alias ber='bundle exec rails'
alias berc='bundle exec rails c'
alias berg-m='bundle exec rails g migration'
alias ber-db-m='bundle exec rake db:migrate'

# ------------------------------
# kubectl (Kubernetes)
# ------------------------------
alias kube='kubectl'
alias kube-prod='kubectl --context production'
alias kube-staging='kubectl --context staging'
alias kube-config='kubectl config view'
alias kube-ctxt='kubectl config get-contexts'
alias kube-c-ctxt='kubectl config current-context'
alias kube-u-ctxt='kubectl config use-context'
alias kube-g='kubectl get'
alias kube-g-s='kubectl get services'
alias kube-g-p='kubectl get pods'
alias kube-g-d='kubectl get deployment'
alias kube-g-n='kubectl get namespaces'
alias kube-g-vs='kubectl get volumesnapshots'
alias kube-d-s='kubectl delete service'
alias kube-d-p='kubectl delete pod'
alias kube-d-n='kubectl delete namespaces'
alias kube-d-d='kubectl delete deployments'
alias kube-watch='watch kubectl get pods --namespace'

# Functions
kube-run-bash() {
  kubectl --context $1 --namespace $2 exec -it $3 /bin/bash
}

kube-snapshot-log() {
  kubectl logs snapshot-controller-d6d84fd85-rd8pn -n kube-system -c $1
}

# ----------------------
# helm
# ----------------------
alias helm-prod="helm --kube-context production"
alias helm-staging="helm --kube-context staging"
alias helm-d="helm delete --purge"

# secrets
alias helm-s-clean="helm secrets clean"
alias helm-s-dec="helm secrets dec"
alias helm-s-enc="helm secrets enc"
alias helm-s-edit="helm secrets edit"
