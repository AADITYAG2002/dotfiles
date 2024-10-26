return {
    "mfussenegger/nvim-lint",
    keys = {
        {
            "<leader>fl",
            function()
                require("lint").try_lint()
            end,
            mode = "n",
            desc = "Linter Buffer",
        },
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        lint.linter_by_ft = {
            python = { "pylint" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}
