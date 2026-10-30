require('snacks').setup {
  picker = {
    -- picker.sources.Config - [picker.Config]
    sources = {
      -- explorer.Config: files.Config: proc.Config: picker.Config
      explorer = {
        layout = {
          -- This is default, but I am leaving it here as beadcrumbs for helping me
          -- figure out how the hell to configure this mess.
          layout = { position = 'left', preview = false },
        },
      },
      -- This will open the buffer list as a split on the right, opposite the explorer. Kind of nice if I decide
      -- I want a buffer list.
      buffers = {
        focus = 'list',
        prompt = ' ',
        auto_close = true,
        layout = {
          preview = 'main',
          layout = {
            cycle = true,
            backdrop = false,
            width = 40,
            min_width = 40,
            height = 0,
            position = 'right',
            border = 'none',
            box = 'vertical',
            {
              win = 'input',
              height = 1,
              border = 'rounded',
              title = '{title} {live} {flags}',
              title_pos = 'center',
            },
            { win = 'list', border = 'none' },
            { win = 'preview', title = '{preview}', height = 0.4, border = 'top' },
          },
        },
      },
    },
  },
  explorer = {
    replace_netrw = true,
    auto_close = true,
  },
  dashboard = {
    preset = {
      header = require('library.ascii_art').samus,
    },
    sections = {
      { section = 'header' },
      { section = 'startup' },
    },
  },
  gitbrowse = { enabled = true },
  statuscolumn = {
    enabled = true,
    folds = {
      open = true,
      git_hl = true,
    },
  },
}
