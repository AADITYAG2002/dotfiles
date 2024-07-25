return {
    
    {
        -- onedarkpro
        "olimorris/onedarkpro.nvim",
        lazy = false,
        priority = 1000,
        config = function ()
            vim.cmd([[
                colorscheme onedark_vivid
                hi NvimTreeRootFolder       guifg=#c99a6e
                hi NvimTreeFolderIcon       guifg=#61afef
                hi NvimTreeOpenedFolderName guifg=#61afef
            ]])

            local onedark = require("onedarkpro")
            local palette = require("onedarkpro.helpers")

            onedark.setup({
                colors = {white = "#ffffff"},
            })

        end
    }
}
