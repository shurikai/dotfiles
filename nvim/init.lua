-- Leader must be set before any plugin creates mappings.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Build steps after a plugin is installed or updated. Registered before
-- vim.pack.add() so it also fires for installs from the lockfile.
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack-hooks', { clear = true }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd 'TSUpdate'
    end
  end,
})

-- Plugins. Exact revisions live in nvim-pack-lock.json (committed).
--   Update:  :lua vim.pack.update()       (review, then :write to apply)
--   Remove:  delete it here, restart, :lua vim.pack.del { 'name' }
local gh = function(repo)
  return 'https://github.com/' .. repo
end
vim.pack.add {
  -- Colorschemes
  gh 'rebelot/kanagawa.nvim',
  gh 'zenbones-theme/zenbones.nvim',
  gh 'rktjmp/lush.nvim',
  gh 'savq/melange-nvim',
  gh 'jacksonludwig/vim-earl-grey',

  -- UI
  gh 'folke/snacks.nvim',
  gh 'echasnovski/mini.nvim',
  gh 'nvim-tree/nvim-web-devicons',
  gh 'nvim-lualine/lualine.nvim',
  gh 'SmiteshP/nvim-navic',
  gh 'lewis6991/gitsigns.nvim',

  -- Syntax
  { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = gh 'nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },

  -- LSP, completion, formatting. nvim-lspconfig only supplies server
  -- defaults (its lsp/*.lua); servers are enabled in plugin/lsp.lua.
  gh 'neovim/nvim-lspconfig',
  gh 'folke/lazydev.nvim',
  -- A release tag, so blink downloads its prebuilt fuzzy matcher (no cargo).
  { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' },
  gh 'rafamadriz/friendly-snippets',
  gh 'stevearc/conform.nvim',

  -- Debugging
  gh 'mfussenegger/nvim-dap',
  gh 'nvim-neotest/nvim-nio',
  gh 'rcarriga/nvim-dap-ui',
  gh 'theHamsta/nvim-dap-virtual-text',
}

require 'plugins.colorscheme'
require 'plugins.snacks'
require 'plugins.mini'
require 'plugins.lualine'
require 'plugins.gitsigns'
require 'plugins.treesitter'
require 'plugins.completion'
require 'plugins.conform'
require 'plugins.debugging'
