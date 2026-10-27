return {
  'saghen/blink.cmp',
  -- use a release tag to download pre-built binaries
  -- version = 'v0.*',
  build = 'cargo build --release',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
    },
    { 'rafamadriz/friendly-snippets' },
  },

  ---@module 'blink.cmp'
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    snippets = {
      expand = function(snippet)
        require('luasnip').lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require('luasnip').jumpable(filter.direction)
        end
        return require('luasnip').in_snippet()
      end,
      jump = function(direction)
        require('luasnip').jump(direction)
      end,
    },
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
    -- your own keymap.
    keymap = { preset = 'super-tab' },

    ---@diagnostic disable-next-line: missing-fields
    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
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

    -- experimental signature help support
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
          -- treesitter = { 'lsp' },
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon', 'kind', gap = 1 },
            -- { 'source_name', gap = 2 },
          },
        },
      },
    },
  },
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { 'sources.default' },
}
