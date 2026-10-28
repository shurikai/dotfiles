# dotfiles

One repo for every machine: the Mac, the Void dev box, the Centene Coder
workspace (reached only through VDI), the Proxmox homelab, and whatever distro
is in a VM this week.

- **chezmoi** places files and templates out per-machine differences.
- **mise** installs the CLI toolchain into `$HOME` at the same versions on
  every OS. **Homebrew** covers only Mac apps and fonts. **SDKMAN** handles Java.
- **Neovim's config is a plain directory in this repo** (`nvim/`), symlinked to
  `~/.config/nvim`. Edit it in place and commit like any repo.

## Roles

Asked once per machine, cached in `~/.config/chezmoi/chezmoi.toml`.
Change with `chezmoi init --prompt`.

| Role | Machine | Shell | WezTerm + font | Toolchain + Neovim | tmux |
|---|---|---|---|---|---|
| `workstation` | MacBook Pro | zsh | yes | yes | yes |
| `devbox` | Void dev box (headless) | zsh | no | yes | yes |
| `work` | Client machine (Coder) | bash, no btop | no (VDI) | yes | yes, the main multiplexer |
| `server` | Proxmox host, homelab | zsh | no | no | yes, from the distro |
| `scratch` | Arch VMs, distro-hopping | zsh | no | yes | yes |

`~/.bashrc` is a full setup on every role (same aliases, fzf, mise and
starship as zsh, minus the zsh-only plugins), so bash is always a usable
fallback.

## Bootstrap: new MacBook Pro (clean install)

1. **Command Line Tools:** `xcode-select --install`
2. **Homebrew:** run the one-liner from <https://brew.sh>, then follow its
   "Next steps" so `brew` is on your PATH for this terminal.
3. **chezmoi and GitHub:**
   ```sh
   brew install chezmoi gh
   gh auth login        # let it create and upload a new SSH key
   ```
4. **Everything else:**
   ```sh
   chezmoi init --apply shurikai
   ```
   Answer `workstation` and your personal email. That one command:
   - installs the Mac packages: WezTerm, IosevkaTerm Nerd Font, eza, btop, mise
   - writes zsh, git, starship, bat, btop, tmux and WezTerm configs
   - downloads zsh-syntax-highlighting and zsh-autosuggestions
   - runs `mise install` (Neovim, starship, tmux, fzf, fd, ripgrep, bat, Go, Node, ...)
   - installs SDKMAN
   - restores Neovim plugins from `nvim/lazy-lock.json`
5. Open **WezTerm**, then `sdk install java <version>` for whatever the
   current engagement needs.

Not handled by the repo: SSH keys (step 3 makes one), app sign-ins, macOS
system settings.

## Bootstrap: Linux machines

```sh
git clone https://github.com/shurikai/dotfiles ~/.local/share/chezmoi
~/.local/share/chezmoi/install.sh
```

Distro packages (git, curl, zsh, compiler, btop or tmux) are installed through
sudo when it's available, so expect a password prompt. Then make zsh your
login shell: `chsh -s "$(command -v zsh)"`.

Non-interactive, e.g. a fresh Proxmox VM or LXC:

```sh
DOTFILES_ROLE=server DOTFILES_EMAIL=you@example.com ./install.sh
```

## Bootstrap: Void dev box (headless, always on)

The Mac is the terminal; the box is where code, toolchains, containers and
long-running work (tests, agents) live. You reconnect to it, never sync.

```sh
sudo xbps-install -Sy git curl
git clone https://github.com/shurikai/dotfiles ~/.local/share/chezmoi
DOTFILES_ROLE=devbox ~/.local/share/chezmoi/install.sh
```

Beyond the usual Linux setup, `run_onchange_after_40-devbox-system.sh.tmpl`
(devbox role on Void only) installs openssh, tailscale, mosh, docker and
restic; enables `sshd`, `tailscaled` and `docker` under runit; generates the
`en_US.UTF-8` locale; adds `AcceptEnv LANG LC_*`; and stops elogind from
suspending the box.

Then, by hand:

1. `sudo tailscale up`, and turn on MagicDNS in the admin console so `devbox`
   resolves from the Mac.
2. `chsh -s "$(command -v zsh)"`, then log out and back in (also picks up
   the docker group).
3. From the Mac: `ssh-copy-id devbox`.
4. On the box: `chezmoi apply`. The system script notices
   `~/.ssh/authorized_keys` and re-runs, this time turning off password and
   keyboard-interactive SSH. It never does that before a key is installed.

Projects go in `~/src` (or `~/src/<group>/<name>`).

**From the Mac** (workstation role adds mosh, Tailscale and `~/.ssh/config`):

- **Cmd-Shift-D** in WezTerm opens a tab on the box via mosh, attached to a
  persistent tmux session called `main`.
- **`tms`** (or **prefix f** inside tmux) fuzzy-picks a project and attaches to
  its own session, creating it if needed.
- WezTerm's leader is also Ctrl-b, so press **Ctrl-b Ctrl-b** to reach tmux.
- Dev servers: bind to `0.0.0.0` and open `http://devbox:<port>` on the Mac.
- `~/.ssh/config` is managed on the Mac: put any other hosts in
  `~/.ssh/config.local`.

## Bootstrap: Coder

Set this repo as the workspace's dotfiles URL (or run
`coder dotfiles https://github.com/shurikai/dotfiles`). Coder runs
`install.sh`, which picks `role=work`. If `env | grep ^CODER` shows nothing on
your image, set `DOTFILES_ROLE=work` in the template or `~/personalize`.

The `work` role uses bash: no zsh, zsh plugins or btop get installed, which
keeps the footprint small on an image you don't control. If the repo is
private, the workspace needs GitHub access through Coder's external auth.

On locked-down networks, `install.sh` and the mise step download chezmoi and
mise from GitHub releases when `get.chezmoi.io` / `mise.run` are blocked.
SDKMAN is attempted once; if `get.sdkman.io` is blocked it prints how to
install it later. If mise hits GitHub's API rate limit, put
`export MISE_GITHUB_TOKEN=...` (a classic token, no scopes) in
`~/.config/bash/local.bash` and run `mise install`.

## Multiplexing: WezTerm and tmux

`tmux.conf` mirrors the WezTerm leader table: same prefix (**Ctrl-b**), same
keys for splits (`s`/`v`), panes (`hjkl`), zoom (`z`), resize (`r`), tabs or
windows (`t`, `[`, `]`), and pickers (`n`, `w`). The VDI workflow and the Mac
workflow feel the same.

- **On the Mac:** WezTerm panes, as now.
- **On Coder through VDI:** tmux. Sessions survive VDI disconnects.
- **SSH from WezTerm into a box running tmux:** WezTerm grabs the first Ctrl-b.
  Press **Ctrl-b Ctrl-b** to pass it through, then the key.

Copy mode is `prefix Escape` (since `[` is previous-window, as in WezTerm).
Yanks use OSC 52, so they reach your local clipboard over SSH.

## Day to day

| Task | Command |
|---|---|
| Edit Neovim config | Edit `~/.config/nvim` directly; commit from `chezmoi cd` |
| Edit any other managed file | `chezmoi edit ~/.zshrc`, then `chezmoi apply` |
| See what apply would change | `chezmoi diff` |
| Track a new file | `chezmoi add ~/.config/foo/config` |
| Pull changes from another machine | `chezmoi update` |
| Go to the repo | `chezmoi cd` |
| Machine-only shell bits | zsh: `~/.config/zsh/local.zsh` or `local.zprofile`; bash: `~/.config/bash/local.bash` (not in the repo) |
| Machine-only git settings | `~/.config/git/local` (not in the repo) |

**The Neovim rule:** run `:Lazy update` on one machine only and commit
`nvim/lazy-lock.json`. Everywhere else, `chezmoi update` pulls it and the
restore script moves plugins to exactly those revisions.

**Versions:** Neovim is pinned in `home/dot_config/mise/config.toml.tmpl`.
The rest float on `latest`; pin one the day it surprises you.

**btop:** its config is written only if it doesn't exist (`create_`), because
btop rewrites the file on exit. To push a change everywhere, edit
`home/dot_config/btop/create_btop.conf` and delete the file on each machine.

## Pending

- **Theme scrub.** Kanagawa in WezTerm, Neovim, starship and tmux; Nord in bat;
  a custom palette in the fzf colors.
- **Neovim rework** on 0.12: vim.pack, `vim.lsp.enable`, built-in completion.
  gopls is still commented out in `lsp-config.lua`.
- **Secrets.** `.trusted` exists for when SSH config or tokens get managed.
