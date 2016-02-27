Forked some existing repos first but soon my setup was so diverse, moved to custom repo now.
Also added the config and installation of [Mackup](https://github.com/lra/mackup)

I use Mackup for backing up and syncing application settings and Dotbot for the simple dotfiles.

This mainly configures:
* several default applications
* git
* zsh and oh-my-zsh
* vim
* a bunch of command line stuff


## install
Run this:

```sh
git clone https://github.com/robsonke/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
sh bootstrap.sh
```

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

## update
```sh
cd ~/.dotfiles
sh update.sh
```
Or use the alias:
```sh
update
```

## mackup
To save all: mackup backup
To restore from dropbox: mackup restore

## custom overrides
To override these defaults, you can add files in a folder named "custom". That's ignored by git but will be loaded by your zsh profile. For example the DEFAULT_USER variable in .zshrc to your own username or the oh-my-zsh plugins.

## thanks
These great tools:
* homebrew
* cask
* zsh
* mackup
* dotbot
* git
* and all people who share their dotfiles for inspiration
