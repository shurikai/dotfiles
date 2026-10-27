return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    options = {
      icons_enabled = true,
      theme = 'kanagawa',
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      always_divide_middle = false,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      },
    },
    sections = {
      lualine_a = {
        {
          'mode',
          icons_enabled = false,
          fmt = function(str)
            return str:sub(1, 1)
          end,
          icon = '',
        },
      },
      lualine_b = {
        { 'filetype', icon_only = true },
        {
          'filename',
          newfile_status = true,
          path = 1,
          symbols = {
            modified = ' ',
            readonly = ' ',
            newfile = ' ',
          },
        },
      },
      lualine_c = {
        {
          function()
            local count = 0
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_get_option_value('modified', { buf = buf }) then
                count = count + 1
              end
            end
            if count > 0 then
              return '󰏫 ' .. count
            end
            return ''
          end,
        },
      },
      lualine_x = { 'searchcount', 'selectioncount' },
      lualine_y = {},
      lualine_z = { 'branch' },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
    winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        function()
          local navic = require 'nvim-navic'
          local has_navic = navic.is_available()
          if has_navic then
            return navic.get_location()
          else
            return vim.fn.expand '%:p:~:.:h'
          end
        end,
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        function()
          local buffers = vim.lsp.get_clients()
          local client_names = {}

          for _, client in ipairs(buffers) do
            if client.name ~= 'null-ls' then
              table.insert(client_names, client.name)
            end
          end
          return vim.fn.join(client_names, ',')
        end,
      },
    },
    tabline = {},
    extensions = { 'quickfix' },
  },
}
