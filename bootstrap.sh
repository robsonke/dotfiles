# Rob's install script
# THIS IS UNTESTED ON NEW OSX INSTALLATIONS!

# install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap caskroom/cask
brew install brew-cask
brew tap homebrew/versions
brew tap homebrew/dupes
brew tap homebrew/completions
brew tap ravenac95/sudolikeaboss
brew tap homebrew/command-not-found
brew tap caskroom/fonts
brew tap homebrew/php

# install all required brew packages
brew update
sh brew/brew.sh
sh brew/brew-cask.sh
brew cleanup

# n - node version management
npm install -g n

# create some default vim folders
mkdir -p ~/.vim/swaps
mkdir -p ~/.vim/backups

# install oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# set zsh as default shell
chsh -s $(which zsh)

# run dotbot
sh dotbot-config/install-dotbot

# and finally, install mackup repo
mackup restore

# set a bunch of default osx settings
sh macos/macos

# install Vundle - vim plugin manager
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# install all vim plugins with Vundle
vim +PluginInstall +qall


# KNOWN MISSING PARTS
# fonts for oh my zsh agnoster theme
# solarized color schemes
# the powerline fonts (clone https://github.com/powerline/fonts and run install.sh)
#   and run: pip install powerline-status
# ssh keys
# ip-up vpn config file
# osx network settings
#
# diversity of software
# - intellij idea
# - yourkit
# - garmin software
# - dropbox
# - skype
# - sql developer


