-- A project's own node_modules/typescript wins. Otherwise fall back to mise's
-- npm:typescript. ts_ls can't find that one itself: mise installs each npm
-- package in its own prefix, and its bin/tsserver is a wrapper script, not a
-- symlink ts_ls could follow.
local function mise_tsserver()
  local bin = vim.fn.exepath 'tsserver' -- <prefix>/node_modules/.bin/tsserver
  if bin == '' then
    return nil
  end
  local js = vim.fs.joinpath(vim.fs.dirname(vim.fs.dirname(bin)), 'typescript', 'lib', 'tsserver.js')
  return vim.uv.fs_stat(js) and js or nil
end

---@type vim.lsp.Config
return {
  init_options = {
    tsserver = { fallbackPath = mise_tsserver() },
    preferences = {
      disableSuggestions = true,
    },
  },
}
