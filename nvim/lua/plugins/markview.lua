return {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons", -- Used by the code bloxks
    },

    config = function()
        require("markview").setup({
            buf_ignore = { "nofile" },
            modes = { "n", "no" },
        })
        vim.api.nvim_set_hl(0, "markdownLinkText", { fg = "#61afef" })
    end,
}
