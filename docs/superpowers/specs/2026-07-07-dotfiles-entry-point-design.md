# Single entry point: `dotfiles install|update|link`

## Problem

`bootstrap.sh` (one-time setup) and `update.sh` (ongoing sync) are two separate scripts that
duplicate the same 3 `ln -sf` calls for `~/.zshrc`, `~/.aliases`, and `~/.functions`. Neither has
any error handling — `update.sh` will run `git push` even if an earlier step (e.g. `brew update`)
failed. Users have to remember which of two commands to run for which purpose.

## Goal

Replace `bootstrap.sh` and `update.sh` with a single executable script, `dotfiles`, at the repo
root, with subcommands for each purpose. No change to *what* each step does — this is a structural
consolidation, not a rewrite of behavior.

## Design

### Commands

- `./dotfiles install` — one-time setup on a new machine. Installs Homebrew, installs the
  brew/cask packages listed in `brew/brew-${USER}.sh` / `brew/brew-cask-${USER}.sh`, sets zsh as
  the default shell, then links dotfiles.
- `./dotfiles update` — keep an existing machine in sync. Pulls latest, re-links dotfiles, upgrades
  Homebrew/Cask packages, regenerates the `brew/brew-*.sh` lists from what's actually installed,
  commits and pushes.
- `./dotfiles link` — (re)create the 3 symlinks only. Used internally by both `install` and
  `update`, and callable standalone (e.g. after moving the repo, or to fix a broken symlink without
  running the rest of `update`).

Running with no argument, or an unrecognized one, prints usage and exits 1.

### Structure

```
#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

usage() { ... }
link_dotfiles() { ln -sf ... x3 }   # single source of truth, replaces the duplicated calls
cmd_install() { ... }               # body = current bootstrap.sh, using link_dotfiles
cmd_update() { ... }                # body = current update.sh, using link_dotfiles

case "${1:-}" in
  install) cmd_install ;;
  update)  cmd_update ;;
  link)    link_dotfiles ;;
  *)       usage; exit 1 ;;
esac
```

`cmd_update` still sources `macos/functions` for `log_info`/`brew_cleanup_all`/`brew_upgrade`/
`brew_cask_upgrade`/`brew_install_missing`/`brew_cask_install_missing`, exactly as `update.sh` does
today. Resolving `DOTFILES_DIR` from `${BASH_SOURCE[0]}` means the script works regardless of
current working directory or where the repo is cloned, rather than hardcoding `~/.dotfiles`.

### Error handling

`set -euo pipefail` is new — neither existing script has any error handling today. This means a
failed step (e.g. `brew update`, `git pull`) now stops the script instead of silently continuing
into later steps like `git push`.

### Files touched

- Add: `dotfiles` (executable, `chmod +x`)
- Remove: `bootstrap.sh`, `update.sh`
- Update: `README.md` (install/update sections, layout table), `CLAUDE.md` (Commands section)

### Testing

No automated tests — this is config, not application code, matching the rest of the repo.
Verification:
- `bash -n dotfiles` — syntax check
- Run `./dotfiles link` for real and confirm `~/.zshrc`, `~/.aliases`, `~/.functions` resolve
- Manual read-through of `cmd_install`/`cmd_update` bodies against the original scripts to confirm
  no behavior was dropped in the move (Homebrew install, `chsh`, brew upgrade/install helpers,
  package list regeneration, `git pull`/`git push`). These two paths touch real system state
  (installs Homebrew, changes the default shell, pushes to a real remote) and are not run
  end-to-end as part of this change.

## Out of scope

- Rewriting the Homebrew install command itself (still the existing, arguably outdated, `ruby -e`
  installer line) — unrelated to this consolidation.
- Adding `set -euo pipefail` retroactively to `macos/functions` — out of scope; only the new
  `dotfiles` script gets it.
- Multi-machine/profile support, CI/shellcheck, Makefile/justfile — deferred; this spec is scoped to
  the single entry point only.
