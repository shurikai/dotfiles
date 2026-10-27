return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
  },
  config = function()
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

    dap.adapters['pwa-node'] = {
      type = 'server',
      host = '127.0.0.1',
      port = '8123',
      executable = {
        command = 'node',
        args = { '/Users/jason/.local/share/js-debug/src/dapDebugServer.js', '8123' },
      },
    }

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

    -- vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DapBreakpoint" })
    vim.fn.sign_define(
      'DapBreakpoint',
      { text = '󰜴', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint', linehl = 'DapLine' }
    )
    vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', numhl = 'DapLogPoint' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', numhl = 'DapStopped' })
  end,
}
