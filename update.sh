#!/bin/sh

cd ~/.dotfiles

# update system
git pull

./install

# Update Homebrew (Cask) & packages
brew update
brew upgrade

# install all from bundle, to avoid overriding missing packages below
./brew.sh
./brew-cask.sh
brew cleanup
brew cask cleanup

# Update npm & packages
npm install npm -g
npm update -g

# Update Ruby & gems
sudo gem update —system
sudo gem update

# and update my brew install file with latest list
brew leaves | sed 's/^/brew install /' > brew.sh
brew cask list | sed 's/^/brew install Caskroom\/cask\//' > brew-cask.sh

# update the mackup references
#mackup backup

# add, commit and push everything
git ca
git push

