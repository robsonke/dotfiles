# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Rob's personal macOS dotfiles. There is no build/test/lint tooling — this is a collection of shell
scripts and config files that get symlinked into the home directory and sourced by zsh. "Correctness"
here means: the scripts run without error on macOS, and symlink targets/sourced paths actually exist.

## Commands

There is no build or test suite. The only commands that matter, all via the single `dotfiles` entry point:

```sh
./dotfiles install   # one-time setup on a new machine: installs Homebrew, brew/cask packages,
                      # sets zsh as default shell, symlinks dotfiles into $HOME
./dotfiles update     # pulls latest, re-symlinks, upgrades/installs brew & cask packages,
                      # regenerates brew/brew-${USER}.sh and brew/brew-cask-${USER}.sh, commits & pushes
./dotfiles link       # just the 3 symlinks, without touching Homebrew or git
```

To sanity-check a shell script edit without running the destructive parts, `bash -n <file>` (syntax
check) or reading through manually is the practical option — there's no CI here.

## Architecture

**Symlink model**: `./dotfiles link` (called by both `install` and `update`) creates exactly 3
symlinks from the repo into `$HOME`:

| Home file      | Repo source           |
|----------------|------------------------|
| `~/.zshrc`     | `zsh/zshrc`            |
| `~/.aliases`   | `macos/aliases`        |
| `~/.functions` | `macos/functions`      |

`zsh/zshrc` in turn sources `~/.aliases` and `~/.functions` at shell startup (a loop over
`~/.{aliases,functions}`, guarded so a missing file is skipped silently). If you add a new file that
should be loaded into the shell, it must either be added to that symlink list *and* the `for file in`
loop in `zsh/zshrc`, or it won't do anything — the repo does not auto-discover files.

**Per-user brew package lists**: `brew/brew-<username>.sh` and `brew/brew-cask-<username>.sh` are
generated (not hand-written) by `./dotfiles update` via `brew list | sed ... > brew/brew-${USER}.sh`.
`./dotfiles install` installs from `brew/brew-${USER}.sh` / `brew/brew-cask-${USER}.sh` (matching the
current `$USER`), so these filenames are expected to vary per machine/user rather than being fixed
names like `brew.sh`.

**Machine-local secrets/overrides**: `overrides/` is git-ignored (see `.gitignore`). `zsh/zshrc` sources
`~/.dotfiles/overrides/local.zsh` if it exists — this is where API tokens or other machine-specific,
non-shareable config belongs. Never put secrets directly in `zsh/zshrc`, `macos/aliases`, or any other
tracked file, since this repo is pushed to a public GitHub remote (`./dotfiles update`'s last step is
`git push`).

**macos/functions** defines the brew maintenance helpers used by `./dotfiles update`
(`brew_cleanup_all`, `brew_upgrade`, `brew_cask_upgrade`, `brew_install_missing`,
`brew_cask_install_missing`, plus faster variants and a shared `log_info` logger). These are bash
functions, sourced into the interactive shell via the `~/.functions` symlink, and also `source`d directly
inside `dotfiles`' `cmd_update`.

**Prompt**: handled entirely by `starship` (`eval "$(starship init zsh)"` in `zsh/zshrc`). There is no
oh-my-zsh, powerlevel10k, or any zsh framework in this setup — those were fully removed. Don't reintroduce
framework-style config (theme variables, plugin arrays) expecting it to do anything; nothing sources
`oh-my-zsh.sh` or similar.

## Working in this repo

- This is single-maintainer config, not a shared codebase — prioritize matching the existing terse,
  comment-per-alias style in `macos/aliases`/`macos/functions` over introducing new structure.
- Before adding a new dotfile/config, check whether it's actually wired up (symlinked via
  `link_dotfiles` in `dotfiles`, and sourced from `zsh/zshrc` if it's shell config) — this repo has a
  history of accumulating files that exist but are never loaded. Dead/unsourced files are worse than no file.
- `macos/aliases` sources two files outside the repo (`$HOME/maxxton/docs/extra_aliases`,
  `$HOME/maxxton/docs/ssh_profiles`) — these are intentionally external/untracked (work-specific,
  sensitive), not broken paths to fix.
