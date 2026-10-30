require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    '${3rd}/luassert/library',
    '${3rd}/busted/library',
    -- Load the wezterm types when the `wezterm` module is required
    -- Needs `justinsgithub/wezterm-types` to be installed
    { path = 'wezterm-types', mods = { 'wezterm' } },
  },
}

---@module 'blink.cmp'
---@diagnostic disable-next-line: missing-fields
require('blink.cmp').setup {
  -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
  keymap = { preset = 'super-tab' },

  -- Use the downloaded Rust matcher; fall back to the Lua one (with a
  -- warning) if the download is blocked.
  fuzzy = { implementation = 'prefer_rust_with_warning' },

  ---@diagnostic disable-next-line: missing-fields
  appearance = {
    -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono',
  },

  -- Snippets use Neovim's built-in vim.snippet and pick up friendly-snippets.
  ---@diagnostic disable-next-line: missing-fields
  sources = {
    default = { 'lazydev', 'lsp', 'snippets', 'path', 'buffer' },
    providers = {
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        -- make lazydev completions top priority (see `:h blink.cmp`)
        score_offset = 100,
      },
    },
  },

  signature = {
    enabled = true,
    window = {
      border = 'single',
    },
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
      window = {
        border = 'single',
      },
    },
    ghost_text = {
      enabled = false, -- The ghost text was getting kind of annoying
    },
    menu = {
      draw = {
        columns = {
          { 'label', 'label_description', gap = 1 },
          { 'kind_icon', 'kind', gap = 1 },
        },
      },
    },
  },
}
