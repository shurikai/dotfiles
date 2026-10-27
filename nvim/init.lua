-- Bootstrap lazy.nvim
--    This will download and install the plugin manager if it isn't already
--    present, then configure it to use lua/plugins for plugin specs. It also
--    applies any configuration that is necessary to get started.
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup 'mapleader' and 'maplocalleader' before loading and initializing lazy.nvim so that
-- mappings are correct after. This is also a good place to setup other settings in vim.opt, etc.

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Setup lazy.nvim
require('lazy').setup {
  spec = {
    { import = 'plugins' },
  },
  -- Configure other lazy settings here. See the documentation for more details.

  -- The colorscheme that will be used when installing plugins.
  install = { colorscheme = { 'habamax' } },
  checker = { enabled = false, notify = false },
  change_detection = { enabled = false },
}
