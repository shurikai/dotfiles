-- nvim-treesitter (main branch) only installs parsers and queries now.
-- Highlighting is Neovim's own (vim.treesitter.start), enabled per buffer below.
-- Compiling parsers needs the tree-sitter CLI (from mise) and a C compiler;
-- without them, Neovim's bundled parsers (lua, vim, vimdoc, markdown, ...) and
-- regex syntax still work.
local M = {}

M.parsers = {
  'bash',
  'diff',
  'go',
  'html',
  'http',
  'java',
  'javascript',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'prisma',
  'python',
  'query',
  'typescript',
  'vim',
  'vimdoc',
}

if vim.fn.executable 'tree-sitter' == 1 and vim.fn.executable 'cc' == 1 then
  require('nvim-treesitter').install(M.parsers) -- async, no-op when installed
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
  callback = function(ev)
    if pcall(vim.treesitter.start, ev.buf) then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- [[ Text objects ]] --
require('nvim-treesitter-textobjects').setup {
  select = {
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'V', -- linewise
      ['@class.outer'] = '<c-v>', -- blockwise
    },
    include_surrounding_whitespace = true,
  },
  move = {
    set_jumps = true, -- whether to set jumps in the jumplist
  },
}

local move = require 'nvim-treesitter-textobjects.move'
local select = require 'nvim-treesitter-textobjects.select'
local swap = require 'nvim-treesitter-textobjects.swap'

for lhs, query in pairs {
  af = '@function.outer',
  ['if'] = '@function.inner',
  ac = '@class.outer',
  ic = '@class.inner',
} do
  vim.keymap.set({ 'x', 'o' }, lhs, function()
    select.select_textobject(query, 'textobjects')
  end, { desc = 'TS select ' .. query })
end
vim.keymap.set({ 'x', 'o' }, 'as', function()
  select.select_textobject('@local.scope', 'locals')
end, { desc = 'TS select scope' })

vim.keymap.set('n', '<leader>a', function()
  swap.swap_next '@parameter.inner'
end, { desc = 'TS swap with next parameter' })
vim.keymap.set('n', '<leader>A', function()
  swap.swap_previous '@parameter.inner'
end, { desc = 'TS swap with previous parameter' })

-- ]d/[d are left to diagnostics (Neovim's defaults).
for lhs, args in pairs {
  [']m'] = { 'goto_next_start', '@function.outer' },
  [']]'] = { 'goto_next_start', '@class.outer' },
  [']o'] = { 'goto_next_start', { '@loop.inner', '@loop.outer' } },
  [']s'] = { 'goto_next_start', '@local.scope', 'locals' },
  [']z'] = { 'goto_next_start', '@fold', 'folds' },
  [']M'] = { 'goto_next_end', '@function.outer' },
  [']['] = { 'goto_next_end', '@class.outer' },
  ['[m'] = { 'goto_previous_start', '@function.outer' },
  ['[['] = { 'goto_previous_start', '@class.outer' },
  ['[M'] = { 'goto_previous_end', '@function.outer' },
  ['[]'] = { 'goto_previous_end', '@class.outer' },
} do
  local fn, query, group = args[1], args[2], args[3] or 'textobjects'
  vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
    move[fn](query, group)
  end, { desc = 'TS ' .. fn:gsub('_', ' ') .. ' ' .. vim.inspect(query) })
end

return M
