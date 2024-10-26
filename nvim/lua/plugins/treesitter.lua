return {
    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "bash", "c", "lua", "markdown", "vim", "vimdoc", "python" },
                -- Autoinstall languages that are not installed
                auto_install = true,
                ignore_install = { "latex" },
                highlight = { enable = true, disable = { "latex" } },
                indent = { enable = true },
            })
        end,
    },
}
