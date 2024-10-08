COLORS = {
    black = "#181a1f",
    bg0 = "#282c34",
    bg1 = "#31353f",
    bg2 = "#393f4a",
    bg3 = "#3b3f4c",
    bg_d = "#21252b",
    bg_blue = "#73b8f1",
    bg_yellow = "#ebd09c",
    fg = "#abb2bf",
    purple = "#c678dd",
    green = "#98c379",
    orange = "#d19a66",
    blue = "#61afef",
    yellow = "#e5c07b",
    cyan = "#56b6c2",
    red = "#e86671",
    grey = "#5c6370",
    light_grey = "#848b98",
    dark_cyan = "#2b6f77",
    dark_red = "#993939",
    dark_yellow = "#93691d",
    dark_purple = "#8a3fa0",
    diff_add = "#31392b",
    diff_delete = "#382b2c",
    diff_change = "#1c3448",
    diff_text = "#2c5372",
}

return {
    "lervag/vimtex",
    lazy = false,                                           -- lazy-loading will disable inverse search
    config = function()
        vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
        vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
        vim.g.vimtex_syntax_enabled = 1
        vim.g.vimtex_view_method = 'zathura'


        -- colorscheme
        vim.api.nvim_set_hl(0, "Special", { fg = '#73b8f1' })
        vim.api.nvim_set_hl(0, "texMathZoneEnv", { fg = COLORS.fg })
        vim.api.nvim_set_hl(0, "texMathOper", { fg = COLORS.purple })
        vim.api.nvim_set_hl(0, "texCmd", { fg = COLORS.red })
        vim.api.nvim_set_hl(0, "Delimiter", { fg = COLORS.light_grey })
    end,
    keys = {
        { "<localLeader>l", "", desc = "+vimtext" },
    },
}
