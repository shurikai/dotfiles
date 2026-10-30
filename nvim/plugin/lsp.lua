-- Language servers. Defaults come from nvim-lspconfig's lsp/<name>.lua;
-- overrides live in this config's lsp/<name>.lua and are merged on top.
-- Binaries come from mise (see ~/.config/mise/config.toml). A server
-- that isn't installed is skipped, so the list can be the same on every machine.
-- blink.cmp adds its completion capabilities to every server on its own.
local servers = {
  'biome',
  'gopls',
  'lua_ls',
  'markdown_oxide',
  'prismals',
  'ts_ls',
  'yamlls',
}
vim.lsp.enable(servers)

vim.diagnostic.config {
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.HINT] = '󰌵',
    },
  },
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method('textDocument/documentSymbol', ev.buf) then
      require('nvim-navic').attach(client, ev.buf)
    end
  end,
})
