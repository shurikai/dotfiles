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

# Linux x86_64: fetch the release binary straight from GitHub. Corporate
# networks that block get.chezmoi.io often still allow github.com.
# Verified against the release's checksums file.
install_chezmoi_from_github() {
    [ "$(uname -s)" = Linux ] && [ "$(uname -m)" = x86_64 ] || return 1
    asset="chezmoi-linux-amd64"
    if ldd --version 2>&1 | grep -qi musl; then asset="chezmoi-linux-amd64-musl"; fi

    base=https://github.com/twpayne/chezmoi/releases
    tag=$(curl -fsSLI -o /dev/null -w '%{url_effective}' --connect-timeout 10 "$base/latest") || return 1
    tag=${tag##*/}                 # .../releases/tag/v2.x.y -> v2.x.y
    case "$tag" in v[0-9]*) ;; *) return 1 ;; esac

    tmp=$(mktemp -d)
    curl -fsSL --connect-timeout 10 -o "$tmp/$asset" "$base/download/$tag/$asset" &&
    curl -fsSL --connect-timeout 10 -o "$tmp/sums" "$base/download/$tag/chezmoi_${tag#v}_checksums.txt" &&
    (cd "$tmp" && grep " $asset\$" sums | sha256sum -c - >/dev/null) || { rm -rf "$tmp"; return 1; }

    mkdir -p "$BIN_DIR"
    mv "$tmp/$asset" "$BIN_DIR/chezmoi"
    chmod +x "$BIN_DIR/chezmoi"
    rm -rf "$tmp"
}

if command -v chezmoi >/dev/null 2>&1; then
    chezmoi=$(command -v chezmoi)
elif [ -x "$BIN_DIR/chezmoi" ]; then
    chezmoi="$BIN_DIR/chezmoi"
elif install_chezmoi_from_github; then
    chezmoi="$BIN_DIR/chezmoi"
else
    mkdir -p "$BIN_DIR"
    sh -c "$(curl -fsLS --connect-timeout 10 get.chezmoi.io)" -- -b "$BIN_DIR"
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
