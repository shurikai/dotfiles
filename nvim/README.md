# Neovim Config

Needs Neovim 0.12+ (`vim.pack`). mise pins the version; see
`home/dot_config/mise/config.toml.tmpl`.

## Layout
- `init.lua`: sets the leader, lists every plugin in one `vim.pack.add()`, then
  loads each `lua/plugins/*.lua`.
- `nvim-pack-lock.json`: exact plugin revisions. Committed.
- `lua/plugins/*.lua`: one file per plugin (or group of plugins), just its setup.
- `plugin/*.lua`: options, keymaps, autocmds and LSP. Neovim sources these
  after `init.lua`.
- `lsp/<server>.lua`: per-server overrides, merged over nvim-lspconfig's defaults.

## Plugins
- Add: put it in the `vim.pack.add()` list in `init.lua`, add a
  `lua/plugins/<name>.lua` if it needs setup, restart.
- Update: `:lua vim.pack.update()`, review, `:write` to apply. Commit the lockfile.
- Remove: delete it from `init.lua`, restart, `:lua vim.pack.del { '<name>' }`.

## Language servers and tools
Installed by mise, not from inside Neovim (no Mason). To add a server:
1. Add its binary to the mise config and run `mise install`.
2. Add its nvim-lspconfig name to `servers` in `plugin/lsp.lua`.
3. Optional: put overrides in `lsp/<name>.lua`.

Servers that aren't installed are skipped, so the list can be the same everywhere.

## Treesitter
nvim-treesitter's `main` branch. Parsers compile locally, so they need the
`tree-sitter` CLI (mise) and a C compiler. Without those, Neovim's bundled
parsers and regex highlighting still work. Update parsers with `:TSUpdate`.
