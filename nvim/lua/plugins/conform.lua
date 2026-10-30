require('conform').setup {
  format_on_save = {
    timeout_ms = 500,
    -- We default to fallback behavior. To override per filetype, change the lsp_format in the formatters_by_ft table.
    lsp_format = 'fallback',
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    -- goimports also organizes imports; it comes from mise.
    go = { 'goimports', 'gofmt' },
    javascript = { 'biome-check', 'biome-organize-imports' },
    typescript = { 'biome-check', 'biome-organize-imports' },
  },
}
