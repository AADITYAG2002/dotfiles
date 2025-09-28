return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        -- import mason
        local mason = require("mason")
        --import mason-lspconfig
        local mason_lspconfig = require("mason-lspconfig")

        --enable mason and configure icons
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })
        -- auto install lsp
        mason_lspconfig.setup({
            ensure_installed = {
                "lua_ls",
                "clangd",
                "pyright",
                "cmake",
                "verible",
            },
            automatic_installation = true,
        })

        require("mason-tool-installer").setup({
            ensure_installed = {
                "isort",
                "black",
                "clang-format",
                "pylint",
            },
        })
    end,
}
