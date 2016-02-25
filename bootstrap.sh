# Rob's install script
# THIS IS UNTESTED ON NEW OSX INSTALLATIONS!

# install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap caskroom/cask
brew install brew-cask
brew tap caskroom/versions

# install all required brew packages
brew bundle

# install oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# set zsh as default shell
chsh -s $(which zsh)

# run dotbot
./install


# and finally, install mackup repo
mackup restore

# set a bunch of default osx settings
sh osx/set-defaults.sh


TODO
aliases.zsh
more vim settings
git/*




# KNOWN MISSING PARTS
# fonts for oh my zsh agnoster theme
#
#
#


