#!/bin/bash

cd ~/.dotfiles
# include functions
source macos/functions

# update system
log_info "Get latest source files from Github"
git pull

# include functions, could be renewed
source macos/functions

# run dotbot install / config
log_info "Run dotbot to link config files"
sh dotbot-config/install-dotbot

# update Homebrew (Cask) & packages
log_info "Brew upgrades and installations"
brew_cleanup_all
brew_upgrade
brew_cask_upgrade

brew cleanup
brew cask cleanup
brew doctor

# install new packages from the lists in brew.sh and brew-cask.sh
brew_install_missing
brew_cask_install_missing

# Update npm & packages
log_info "Update NPM packages"
npm install npm -g
npm update -g

# update Ruby & gems
log_info "Update Gems"
sudo gem update —system
sudo gem update

# and update my brew and cask install file with latest list
log_info "Update brew and cask install files"
brew leaves | sed 's/^/brew install /' > brew/brew.sh
brew cask list | sed 's/^/brew cask install /' > brew/brew-cask.sh
mas list | sort > macos/appstore.lst

# update the mackup references
#mackup backup

# add, commit and push everything
log_info "Push everything back to Github"
git ca
git push

