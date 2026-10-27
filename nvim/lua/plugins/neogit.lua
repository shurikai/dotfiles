return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
    -- Only one of these is needed.
    -- 'nvim-telescope/telescope.nvim', -- optional
    -- 'ibhagwan/fzf-lua', -- optional
    'echasnovski/mini.pick', -- optional
  },
  opts = {
    auto_refresh = true,
    disable_builtin_notifications = false,
    use_magit_keybindings = false,
    graph_style = 'unicode',
    -- Change the default way of opening neogit
    kind = 'floating',
    commit_editor = {
      kind = 'split',
    },
    -- Change the default way of opening the commit popup
    commit_popup = {
      kind = 'split',
    },
    -- Change the default way of opening popups
    popup = {
      kind = 'split',
    },
    -- customize displayed signs
    signs = {
      -- { CLOSED, OPENED }
      hunk = { ' ', '󰘍 ' },
      item = { ' ', '󰘍 ' },
      section = { ' ', '󰘍 ' },
    },
  },
}
