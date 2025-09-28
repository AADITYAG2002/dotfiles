return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        views = {
            cmdline_popup = {
                border = {
                    style = "none",
                    padding = { 1, 2 },
                },
                filter_options = {},
                win_options = {
                    winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                },
                position = {
                    row = 10,
                    col = "50%",
                },
                size = {
                    width = 60,
                    height = "auto",
                },
            },
            popupmenu = {
                relative = "editor",
                position = {
                    row = 14,
                    col = "50%",
                },
                size = {
                    width = 60,
                    height = 10,
                },
                border = {
                    style = { '*', "─", "*", "", "", "", "", "" },
                    padding = { 1, 2 },
                },
                win_options = {
                    winhighlight = { Normal = "NormalFloat", FloatBorder = "DiagnosticInfo" },
                },
            },
        },
        preset = {
            bottom_search = true,
            commnd_pallete = true,
            long_message_to_split = true,
            lsp_doc_border = true,
        },
        -- cmdline = {
        --     view = "cmdline",
        -- },
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            },
        },
    },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
    }
}
