return {
    -- tokyonight
    -- "folke/tokyonight.nvim",
    -- lazy = false,
    -- priority = 1000,
    -- opts = {
    --     style = "night",
    -- },
    -- config = function ()
    --     vim.cmd[[colorscheme tokyonight]]
    -- end

    -- onedark
    "navarasu/onedark.nvim",
    lazy = false,
    opts = {
       style = 'warmer'
    },
    config = function ()
       vim.cmd[[colorscheme onedark]]
    end
}
