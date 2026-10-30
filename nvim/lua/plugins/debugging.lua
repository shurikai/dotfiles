local dap = require 'dap'
local dapui = require 'dapui'
local vt = require 'nvim-dap-virtual-text'

dapui.setup()
---@diagnostic disable-next-line: missing-fields
vt.setup {
  enabled = true,
}
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

-- js-debug comes from mise (github:microsoft/vscode-js-debug). Look it up
-- only when a session starts, so startup doesn't shell out to mise.
dap.adapters['pwa-node'] = function(callback)
  local res = vim.system({ 'mise', 'where', 'github:microsoft/vscode-js-debug' }, { text = true }):wait()
  local server = vim.trim(res.stdout or '') .. '/src/dapDebugServer.js'
  if res.code ~= 0 or not vim.uv.fs_stat(server) then
    vim.notify('js-debug not found; run `mise install`', vim.log.levels.ERROR)
    return
  end
  callback {
    type = 'server',
    host = '127.0.0.1',
    port = '${port}',
    executable = { command = 'node', args = { server, '${port}' } },
  }
end

for _, language in ipairs { 'typescript', 'javascript' } do
  dap.configurations[language] = {
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch ts/js file',
      program = '${file}',
      cwd = '${workspaceFolder}',
      -- runtimeExecutable = 'node',
    },
  }
end

vim.fn.sign_define(
  'DapBreakpoint',
  { text = '󰜴', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint', linehl = 'DapLine' }
)
vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', numhl = 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', numhl = 'DapStopped' })
