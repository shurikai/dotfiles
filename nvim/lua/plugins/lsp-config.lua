return {
  { 'SmiteshP/nvim-navic', opts = { highlight = true } },
  {
    'williamboman/mason.nvim',
    lazy = false,
    opts = {
      ensure_installed = {
        'biome',
        'lua_ls',
        'stylua',
        'typescript-language-server',
        'yaml-language-server',
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    lazy = false,
    opts = {
      servers = {
        biome = {},
        yamlls = {},
        markdown_oxide = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim', 'Snacks' },
              },
            },
          },
        },
        prismals = {},
        ts_ls = {
          init_options = {
            preferences = {
              disableSuggestions = true,
            },
          },
        },
        -- gopls = {
        --     cmd = { "gopls" },
        --     filetypes = { "go", "gomod", "gowork", "gotmpl" },
        --     root_dir = require("lspconfig.util").root_pattern("go.work", "go.mod", ".git"),
        --     settings = {
        --         gopls = {
        --             completeUnimported = true,
        --             usePlaceholders = true,
        --             analyses = {
        --                 unusedparams = true,
        --             },
        --         },
        --     },
        -- },
      },
    },
    config = function(_, opts)
      local blink = require 'blink.cmp'
      local lspconfig = require 'lspconfig'
      local navic = require 'nvim-navic'

      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end
      end

      for server, config in pairs(opts.servers) do
        config.capabilities = blink.get_lsp_capabilities(config.capabilities)
        config.on_attach = on_attach
        lspconfig[server].setup(config)
      end
    end,
  },
}
