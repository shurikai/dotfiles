return {
    'lewis6991/gitsigns.nvim',
    event = 'BufEnter',
    cmd = 'Gitsigns',
    opts = {
        signs_staged_enable = true,
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        on_attach = function(bufnr)
            local gitsigns = require('gitsigns')

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
                if vim.wo.diff then
                    vim.cmd.normal({']c', bang = true})
                else
                    gitsigns.nav_hunk('next')
                end
            end, { desc = 'GS Next Hunk' })

            map('n', '[c', function()
                if vim.wo.diff then
                    vim.cmd.normal({'[c', bang = true})
                else
                    gitsigns.nav_hunk('prev')
                end
            end, { desc = 'GS Prev Hunk' })

            -- Actions
            map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'GS Stage Hunk' })
            map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'GS Reset Hunk' })

            map('v', '<leader>hs', function()
                gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, { desc = 'GS Stage Hunk (V)' })

            map('v', '<leader>hr', function()
                gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, { desc = 'GS Reset Hunk (V)' })

            map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'GS Stage Buffer' })
            map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'GS Reset Buffer' })
            map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'GS Preview Hunk' })
            map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'GS Preview Hunk Inline' })

            map('n', '<leader>hb', function()
                gitsigns.blame_line({ full = true })
            end, { desc = 'GS Blame Line' })

            map('n', '<leader>hd', gitsigns.diffthis, { desc = 'GS Diff This' })

            map('n', '<leader>hD', function()
                gitsigns.diffthis('~')
            end, { desc = 'GS Diff This With ~' })

            map('n', '<leader>hQ', function() gitsigns.setqflist('all') end, { desc = 'GS QF List' } )
            map('n', '<leader>hq', gitsigns.setqflist, { desc = 'GS QF List' })

            -- Toggles
            map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'GS Toggle Current Line Blame' })
            map('n', '<leader>td', gitsigns.toggle_deleted, { desc = 'GS Toggle Deleted' })
            map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = 'GS Toggle Word Diff' })

            -- Text object
            map({'o', 'x'}, 'ih', gitsigns.select_hunk, { desc = 'GS Select Hunk' })
        end,
    }
}
