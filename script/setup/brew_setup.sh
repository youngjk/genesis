#!/usr/bin/env bash

## Prompt administrator password upfront (pre-installations)
sudo -v

## Keep-alive: update existing `sudo` time stamp until script finishes
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

## Homebrew check (Update/Install)
# Install (If not installed)
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
# Update Homebrew andd packages to latest version
brew update
brew upgrade
brew cleanup -s
brew doctor

## GNU core utilities (OSX => Outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum
# Install some other useful GNU utilities.
brew install \
  moreutils \
  findutils \
  gnu-sed
# Install Bash 4.
brew install \
  bash \
  bash-completion2
# Activate newest shell
echo "Adding the newly installed shell to the list of allowed shells"
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
chsh -s /usr/local/bin/bash

## Programming Language Setup
# Golang
brew install go
# Python
brew install python python3
# Java
brew cask install java
# ruby-build and rbenv
brew install \
  ruby-build \
  rbenv

## Useful/Essential binaries
brew install \
  imagemagick \
  ack \
  dark-mode \
  libffi \
  lua \
  lynx \
  p7zip \
  pandoc \
  pigz \
  pkg-config \
  pv \
  rename \
  rhino \
  speedtest_cli \
  ssh-copy-id \
  tree \
  webkit2png \
  zopfli \
  htop

## DevOps
brew install \
  docker \
  terraform \
  helm

## GCLOUD
curl https://sdk.cloud.google.com | bash

## GIT
brew install \
  git \
  git-extras \
  git-flow \
  git-lfs \
  hub \
  github/gh/gh

## Step Cask Installations (Applications)
# Text editors
brew cask install --appdir="/Applications" \
  visual-studio-code \
  iterm2
Browsers
brew cask install --appdir="/Applications" \
  google-chrome \
  firefox
# Communication & SNS
brew cask install --appdir="/Applications" \
  skype \
  slack \
  zoomus \
  whatsapp
# Storage / Creds
brew cask install --appdir="/Applications" \
  dropbox \
  evernote \
  sourcetree \
  1password

## Quick Look/View plugins https://github.com/sindresorhus/quick-look-plugins
brew cask install \
  betterzip \
  qlcolorcode \
  qlimagesize \
  qlmarkdown \
  qlprettypatch \
  qlstephen \
  qlvideo \
  quicklook-csv \
  quicklook-json \
  quicklookase \
  suspicious-package \
  webpquicklook

## Font tools
brew tap bramstein/webfonttools
brew install \
  sfnt2woff \
  sfnt2woff-zopfli \
  woff2

## Remove outdated versions from the cellar.
brew cleanup