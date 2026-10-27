vim.cmd 'let g:netrw_liststyle = 3'
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.wrap = false
vim.opt.scrolloff = 6
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.opt.signcolumn = 'yes'
vim.opt.backspace = 'indent,eol,start'
vim.opt.clipboard:append 'unnamedplus'
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.swapfile = false
vim.opt.showmode = false
vim.opt.undofile = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldtext = ''
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 4
vim.opt.foldnestmax = 4
vim.opt.foldcolumn = 'auto'

vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticSignHint' })
