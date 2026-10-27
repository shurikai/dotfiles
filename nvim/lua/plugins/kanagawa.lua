return {
  'rebelot/kanagawa.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('kanagawa').setup {
      commentStyle = { italic = true },
      keywordStyle = { italic = false },
      dimInactive = true,
      terminalColors = true,
      theme = 'dragon',
      background = {
        dark = 'dragon',
        light = 'lotus',
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          NavicIconsFile = { fg = theme.vcs.changed, bold = false },
          NavicIconsModule = { fg = theme.vcs.changed, bold = false },
          NavicIconsNamespace = { fg = theme.vcs.changed, bold = false },
          NavicIconsPackage = { fg = theme.vcs.changed, bold = false },
          NavicIconsClass = { fg = theme.vcs.changed, bold = false },
          NavicIconsMethod = { fg = theme.vcs.changed, bold = false },
          NavicIconsProperty = { fg = theme.vcs.changed, bold = false },
          NavicIconsField = { fg = theme.vcs.changed, bold = false },
          NavicIconsConstructor = { fg = theme.vcs.changed, bold = false },
          NavicIconsEnum = { fg = theme.vcs.changed, bold = false },
          NavicIconsInterface = { fg = theme.vcs.changed, bold = false },
          NavicIconsFunction = { fg = theme.vcs.changed, bold = false },
          NavicIconsVariable = { fg = theme.vcs.changed, bold = false },
          NavicIconsConstant = { fg = theme.vcs.changed, bold = false },
          NavicIconsString = { fg = theme.vcs.changed, bold = false },
          NavicIconsNumber = { fg = theme.vcs.changed, bold = false },
          NavicIconsBoolean = { fg = theme.vcs.changed, bold = false },
          NavicIconsArray = { fg = theme.vcs.changed, bold = false },
          NavicIconsObject = { fg = theme.vcs.changed, bold = false },
          NavicIconsKey = { fg = theme.vcs.changed, bold = false },
          NavicIconsNull = { fg = theme.vcs.changed, bold = false },
          NavicIconsEnumMember = { fg = theme.vcs.changed, bold = false },
          NavicIconsStruct = { fg = theme.vcs.changed, bold = false },
          NavicIconsEvent = { fg = theme.vcs.changed, bold = false },
          NavicIconsOperator = { fg = theme.vcs.changed, bold = false },
          NavicIconsTypeParameter = { fg = theme.vcs.changed, bold = false },
          NavicText = { fg = theme.syn.string, bold = false },
          NavicSeparator = { fg = theme.vcs.removed, bold = false },

          DapBreakpoint = { fg = theme.diag.ok, bold = true },
          DapLogPoint = { fg = theme.diag.warning, bold = true },
          DapStopped = { fg = theme.diag.error, bold = true },
          DapLine = { bg = theme.diff.text },

          -- Rainbow Delimiters - The red is kind of an eye-bleed color, so replace it
          -- with a tamer color scheme color.
          RainbowDelimiterRed = { fg = theme.term[10] },

          -- BlinkCmpMenu = { bg = theme.ui.bg_p2 },
          -- BlinkCmpMenuBorder = { bg = theme.diag.error },
          -- BlinkCmpMenuSelection = { bg = theme.syn.number, fg = theme.term[9] },
          -- BlinkCmpSignatureHelp = { bg = theme.diag.hint },
        }
      end,
    }
    vim.cmd.colorscheme 'kanagawa-wave'
  end,
}

