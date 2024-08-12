return {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
        local ufo = require("ufo")

        vim.o.foldcolumn = '6'
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        ufo.setup({
            close_fold_kinds_for_ft = {
                default = { 'imports', 'comment' },
                json = { 'array' },
                c = { 'comment', 'region' }
            },
            open_fold_hl_timeout = 0,
            provider_selector = function(_, filetype)
                return { 'treesitter', 'indent' }
            end,
            fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate)
                local newVirtText = {}
                local suffix = (' 󰁂 %d '):format(end_lnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virt_text) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, 'MoreMsg' })
                return newVirtText
            end,
            -- fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate)
            --     local _start = lnum - 1
            --     local _end = end_lnum - 1
            --     local start_text = vim.api.nvim_buf_get_text(0, _start, 0, _start, -1, {})[1]
            --     local final_text = vim.trim(vim.api.nvim_buf_get_text(0, _end, 0, _end, -1, {})[1])
            --     return start_text .. ' ⋯ ' .. final_text .. (' 󰁂 %d '):format(end_lnum - lnum)
            -- end,
        })

        vim.api.nvim_set_hl(0, "UfoCursorFoldedLine", { fg = 'NONE' })

        vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
        vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
        vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
        vim.keymap.set('n', 'zP', function()
            local winid = require('ufo').peekFoldedLinesUnderCursor()
            if not winid then
                -- choose one of coc.nvim and nvim lsp
                -- vim.fn.CocActionAsync('definitionHover') -- coc.nvim
                vim.lsp.buf.hover()
            end
        end)
    end
}
