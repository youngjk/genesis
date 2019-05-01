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

# mkdir + cd into dir
mkcd() {
  mkdir -p "$1" && cd "$1"
}
