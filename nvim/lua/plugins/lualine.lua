local colors = {
    bg = "#282c34",
    fg = "#abb2bf",
    red = "#ef596f",
    orange = "#d19a66",
    yellow = "#e5c07b",
    green = "#89ca78",
    cyan = "#2bbac5",
    blue = "#61afef",
    purple = "#d55fde",
    white = "#abb2bf",
    light_black = "#292d35",
    black = "#1d2229",
    gray = "#5c6370",
    highlight = "#e2be7d",
    comment = "#7f848e",
    none = "NONE",
}

local custom_theme = {
    normal = {
        a = { fg = colors.black, bg = colors.blue, gui = "bold" },
        b = { fg = colors.red, bg = colors.light_black },
        c = { fg = colors.white, bg = colors.black },
        y = { fg = colors.cyan, bg = colors.light_black },
        z = { fg = colors.black, bg = colors.yellow },
    },
    insert = {
        a = { fg = colors.black, bg = colors.purple, gui = "bold" },
        z = { fg = colors.black, bg = colors.yellow, gui = "bold" },
    },
    visual = {
        a = { fg = colors.black, bg = colors.cyan, gui = "bold" },
        z = { fg = colors.black, bg = colors.yellow, gui = "bold" },
    },
    replace = {
        a = { fg = colors.black, bg = colors.green, gui = "bold" },
        z = { fg = colors.black, bg = colors.yellow, gui = "bold" },
    },
    command = {
        a = { fg = colors.black, bg = colors.yellow, gui = "bold" },
        z = { fg = colors.black, bg = colors.yellow, gui = "bold" },
    },
}

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = function()
        local lualine = require("lualine")
        local noice = require("noice")

        lualine.setup({
            options = {
                theme = custom_theme,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = {
                    {
                        "mode",
                        icon = " ",
                        separator = { left = "", right = "" },
                    },
                },
                lualine_b = {
                    {
                        "filetype",
                        icon_only = true,
                        -- colored = false,
                        icon = { align = "left" },
                        -- color = {fg = colors.light_black, bg = colors.red},
                        -- separator = "",
                        padding = { left = 1, right = 0 },
                    },
                    {
                        "filename",
                        path = 0,
                        -- separator = { right = ''},
                        padding = { left = 1 },
                    },
                },
                lualine_c = {
                    {
                        "branch",
                        icon = "",
                    },
                    {
                        "diff",
                        colored = true,
                        symbols = { added = " ", modified = " ", removed = " " },
                    },
                    {
                        noice.api.status.command.get,
                        cond = noice.api.status.command.has,
                    },
                    {
                        "%=",
                    },
                    {
                        function()
                            local msg = "No Active Lsp"
                            local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
                            local clients = vim.lsp.get_clients()
                            if next(clients) == nil then
                                return msg
                            end
                            for _, client in ipairs(clients) do
                                local filetypes = client.config.filetypes
                                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                                    return client.name
                                end
                            end
                            return msg
                        end,
                        icon = " LSP:",
                    },
                    {
                        function()
                            local ok, conform = pcall(require, "conform")
                            local formatters = table.concat(conform.formatters_by_ft[vim.bo.filetype], " ")
                            if ok then
                                local format = ""
                                for formatter in formatters:gmatch("%w+") do
                                    format = format .. formatter .. " "
                                end
                                return format
                            end
                        end,
                        icon = "󱇧 Formatter:",
                    },
                },
                lualine_x = {
                    {
                        "diagnostics",
                        sections = { "error", "warn", "info", "hint" },
                        symbols = { error = " ", warn = " ", info = " ", hint = " " },
                        colored = false,
                        always_visible = true,
                    },
                },
                lualine_y = { "encoding", "fileformat" },
                lualine_z = {
                    {
                        "location",
                        icon = " ",
                    },
                    {
                        "progress",
                        separator = { right = "" },
                    },
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
        })
    end,
}
