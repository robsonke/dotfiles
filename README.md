# dotfiles

Personal macOS dotfiles: zsh config, Homebrew package lists, and a pile of shell aliases/functions
for git, Docker, Kubernetes, and general command-line use.

## what's here

* **zsh** — `zsh/zshrc`, prompt via [starship](https://starship.rs)
* **Homebrew** — per-machine package lists in `brew/`, kept in sync by `./dotfiles update`
* **aliases & functions** — `macos/aliases` and `macos/functions`, covering `kubectl`/`docker`
  shortcuts, Homebrew maintenance helpers, and misc utilities

## install

```sh
git clone https://github.com/robsonke/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./dotfiles install
```

This installs Homebrew and the packages listed in `brew/`, installs and enables zsh, and symlinks
`~/.zshrc`, `~/.aliases`, and `~/.functions` into this repo. Everything is configured and tweaked
from `~/.dotfiles`.

## update

```sh
cd ~/.dotfiles
./dotfiles update
```

Pulls the latest changes, re-symlinks the dotfiles, upgrades/installs Homebrew packages, regenerates
the `brew/brew-*.sh` package lists from what's actually installed, and pushes any changes back.

`./dotfiles link` re-creates just the 3 symlinks, without touching Homebrew or git.

## layout

| Path                | Purpose                                                          |
|----------------------|-------------------------------------------------------------------|
| `dotfiles`           | Single entry point: `install`, `update`, `link`                 |
| `zsh/zshrc`          | Symlinked to `~/.zshrc`                                          |
| `macos/aliases`      | Symlinked to `~/.aliases`, sourced by `zshrc`                    |
| `macos/functions`    | Symlinked to `~/.functions`, sourced by `zshrc` and `./dotfiles update` |
| `brew/brew-*.sh`     | Per-user, auto-generated Homebrew/Cask install lists             |
| `overrides/`         | Machine-local secrets & overrides, git-ignored (see below)       |

## secrets & machine-local overrides

Anything sensitive or machine-specific — API tokens, local-only env vars — goes in
`overrides/local.zsh`. It's git-ignored and automatically sourced by `zsh/zshrc` if present. Never
add secrets to any tracked file; this repo is pushed to a public GitHub remote.
