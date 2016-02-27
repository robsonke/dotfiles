Forked some existing repos first but soon my setup was so diverse, moved to custom repo now.
Also added the config and installation of [Mackup](https://github.com/lra/mackup)

I use Mackup for backing up and syncing application settings and Dotbot for the simple dotfiles.


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

# mackup
To save all: mackup backup
To restore from dropbox: mackup restore

## thanks

These great tools:
* homebrew
* cask
* zsh
* mackup
* dotbot
* git
