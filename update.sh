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
brew doctor

# install new packages from the lists in brew.sh and brew-cask.sh
brew_install_missing
brew_cask_install_missing

# update vim plugins
cd ~/.vim_runtime
git pull --rebase
python update_plugins.py

# and update my brew and cask install file with latest list per user (separating work and private)
log_info "Update brew and cask install files"
brew list | sed 's/^/brew install /' > brew/brew-${USER}.sh
brew list --cask | sed 's/^/brew install --cask /' > brew/brew-cask-${USER}.sh


# update the mackup references
#mackup backup

# add, commit and push everything
log_info "Push everything back to Github"
git ca
git push

