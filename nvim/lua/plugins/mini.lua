require('mini.ai').setup()
require('mini.surround').setup()
require('mini.bracketed').setup()
require('mini.indentscope').setup { symbol = '▏' }
require('mini.align').setup()

-- Highlight hex colors (#rrggbb) in their own color. Replaces nvim-colorizer.
local hipatterns = require 'mini.hipatterns'
hipatterns.setup {
  highlighters = {
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
}
