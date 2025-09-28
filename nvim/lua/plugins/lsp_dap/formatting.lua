return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
        {
            "<leader>fr",
            function()
                require("conform").format({ async = false, lsp_format = "fallback", timeout_ms = 500 })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },

    opts = {
        formatters_by_ft = {
            python = { "isort", "black" },
            c = { "clang-format" },
            lua = { "stylua" },
            latex = { "latexindent" },
            verilog = { "verible" }
        },

        format_on_save = { timeout_ms = 500, lsp_format = "fallback", async = false },

        formatters = {
            clang_format = {
                prepend_args = { "--style=file:/home/aaditya/.clang_format" },
            },
            verible = {
                command = "verible-verilog-format",
                append_args = {
                    "--indentation_spaces",
                    "4",
                }
            }
        },
    },
}
