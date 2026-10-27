#!/bin/sh
# Bootstrap entry point for Linux machines and Coder. Safe to re-run.
# (On a Mac, use the steps in README.md: Homebrew first, then chezmoi.)
#
#   Coder:            `coder dotfiles <repo>` clones this repo and runs this file.
#   From a clone:     git clone https://github.com/shurikai/dotfiles ~/.local/share/chezmoi && ~/.local/share/chezmoi/install.sh
#   No clone yet:     sh -c "$(curl -fsSL https://raw.githubusercontent.com/shurikai/dotfiles/main/install.sh)"
#
# Environment overrides:
#   DOTFILES_ROLE   workstation | devbox | work | server | scratch
#                   (skips the prompt; required where there's no TTY)
#   DOTFILES_EMAIL  personal git email (skips that prompt; unused for role=work)
#   DOTFILES_REPO   defaults to shurikai/dotfiles
#
# The prompt strings below must match home/.chezmoi.toml.tmpl: chezmoi's
# --prompt* overrides are keyed by prompt text, not variable name.
set -eu

REPO="${DOTFILES_REPO:-shurikai/dotfiles}"
BIN_DIR="${HOME}/.local/bin"
script_dir=$(cd -- "$(dirname -- "$0")" && pwd)

role="${DOTFILES_ROLE:-}"
# Coder sets CODER / CODER_WORKSPACE_NAME inside workspaces. If your image
# doesn't (check `env | grep ^CODER`), set DOTFILES_ROLE=work instead.
if [ -z "$role" ] && [ -n "${CODER:-}${CODER_WORKSPACE_NAME:-}" ]; then
    role=work
fi

if command -v chezmoi >/dev/null 2>&1; then
    chezmoi=$(command -v chezmoi)
elif [ -x "$BIN_DIR/chezmoi" ]; then
    chezmoi="$BIN_DIR/chezmoi"
else
    mkdir -p "$BIN_DIR"
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$BIN_DIR"
    chezmoi="$BIN_DIR/chezmoi"
fi

set -- init --apply
[ -n "$role" ] && set -- "$@" --promptChoice "Machine role=$role"
[ -n "${DOTFILES_EMAIL:-}" ] && set -- "$@" --promptString "Personal git email=$DOTFILES_EMAIL"

if [ -f "$script_dir/.chezmoiroot" ]; then
    # Running from a checkout (Coder or a manual clone): use it in place.
    exec "$chezmoi" "$@" --source "$script_dir"
else
    exec "$chezmoi" "$@" "$REPO"
fi
