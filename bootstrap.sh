# Rob's install script
# THIS IS UNTESTED ON NEW OSX INSTALLATIONS!

# install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install all required brew packages
brew update
brew tap homebrew/cask-versions
sh brew/brew.sh
sh brew/brew-cask.sh
brew cleanup

# install oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# set zsh as default shell
chsh -s $(which zsh)

# run dotbot
sh dotbot-config/install-dotbot

# set a bunch of default osx settings
sh macos/macos

# install Vim plus a bunch of other plugins / settings
# uses https://github.com/amix/vimrc.git
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

# KNOWN MISSING PARTS
# the powerline fonts (clone https://github.com/powerline/fonts and run install.sh)
#   and run: pip install powerline-status
# ssh keys
# 


