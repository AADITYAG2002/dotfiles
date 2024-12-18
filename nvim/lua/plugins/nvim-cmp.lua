local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
}

local cmp_colors = {
    PmenuSel = { bg = "#282C34", fg = "NONE" },
    Pmenu = { fg = "#C5CDD9", bg = "#22252A" },

    CmpItemAbbrDeprecated = { fg = "#7E8294", bg = "NONE", strikethrough = true },
    CmpItemAbbrMatch = { fg = "#82AAFF", bg = "NONE", bold = true },
    CmpItemAbbrMatchFuzzy = { fg = "#82AAFF", bg = "NONE", bold = true },
    CmpItemMenu = { fg = "#C792EA", bg = "NONE", italic = true },

    CmpItemKindField = { fg = "#EED8DA", bg = "NONE" },
    CmpItemKindProperty = { fg = "#EED8DA", bg = "NONE" },
    CmpItemKindEvent = { fg = "#EED8DA", bg = "NONE" },

    CmpItemKindText = { fg = "#C3E88D", bg = "NONE" },
    CmpItemKindEnum = { fg = "#C3E88D", bg = "NONE" },
    CmpItemKindKeyword = { fg = "#C3E88D", bg = "NONE" },

    CmpItemKindConstant = { fg = "#FFE082", bg = "NONE" },
    CmpItemKindConstructor = { fg = "#FFE082", bg = "NONE" },
    CmpItemKindReference = { fg = "#FFE082", bg = "NONE" },

    CmpItemKindFunction = { fg = "#EADFF0", bg = "NONE" },
    CmpItemKindStruct = { fg = "#EADFF0", bg = "NONE" },
    CmpItemKindClass = { fg = "#EADFF0", bg = "NONE" },
    CmpItemKindModule = { fg = "#EADFF0", bg = "NONE" },
    CmpItemKindOperator = { fg = "#EADFF0", bg = "NONE" },

    CmpItemKindVariable = { fg = "#C5CDD9", bg = "NONE" },
    CmpItemKindFile = { fg = "#C5CDD9", bg = "NONE" },

    CmpItemKindUnit = { fg = "#F5EBD9", bg = "NONE" },
    CmpItemKindSnippet = { fg = "#F5EBD9", bg = "NONE" },
    CmpItemKindFolder = { fg = "#F5EBD9", bg = "NONE" },

    CmpItemKindMethod = { fg = "#DDE5F5", bg = "NONE" },
    CmpItemKindValue = { fg = "#DDE5F5", bg = "NONE" },
    CmpItemKindEnumMember = { fg = "#DDE5F5", bg = "NONE" },

    CmpItemKindInterface = { fg = "#D8EEEB", bg = "NONE" },
    CmpItemKindColor = { fg = "#D8EEEB", bg = "NONE" },
    CmpItemKindTypeParameter = { fg = "#D8EEEB", bg = "NONE" },
}


return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        -- autocompletion
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-path",
        --snippets
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        -- Latex
        {
            "micangl/cmp-vimtex",
            ft = { "tex", "bib" },
            config = true,
        },
        -- {
        --     "onsails/lspkind-nvim",
        --     config = function()
        --         require("lspkind").init()
        --     end,
        -- },
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local cmp_buffer = require("cmp_buffer")
        -- local lspkind = require('lspkind')

        vim.api.nvim_set_hl(0, "CmpItemKindText", cmp_colors.CmpItemKindText)

        require("luasnip.loaders.from_vscode").lazy_load()
        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "vimtex" },
                { name = "buffer" },
                { name = "path" },
            }),
            window = {
                completion = {
                    border = "rounded",
                    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
                },
                documentation = {
                    border = "rounded",
                    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
                },
            },
            formatting = {
                format = function(entry, vim_item)
                    local lspkind_ok, lspkind = pcall(require, "lspkind")
                    if not lspkind_ok then
                        -- From kind_icons array
                        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
                        -- Source
                        vim_item.menu = ({
                            -- vimtex = "[Vimtex]" .. (vim_item.menu ~= nil and vim_item.menu or ""),
                            vimtex = vim_item.menu,
                            buffer = "[Buffer]",
                            nvim_lsp = "[LSP]",
                            luasnip = "[LuaSnip]",
                            nvim_lua = "[Lua]",
                        })[entry.source.name]

                        vim_item.dup = ({
                            vimtex = 0,
                            buffer = 0,
                            nvim_lsp = 0,
                            luasnip = 0,
                        })[entry.source.name] or 0
                        return vim_item
                    else
                        -- From lspkind
                        return lspkind.cmp_format({
                            mode = "symbol_text",
                            maxwidth = 50,
                            show_labelDetails = true,
                        })(entry, vim_item)
                    end
                end
                -- format = lspkind.cmp_format({
                --     mode = 'symbol_text',
                --     maxwidth = 50,
                --     ellipsis_char = '...',
                --     show_labelDetails = true,
                --     menu = ({
                --         buffer = "[Buffer]",
                --         nvim_lsp = "[LSP]",
                --         luasnip = "[LusSnip]",
                --         latex_symbols = "[Latex]",
                --     })

                -- before = function(_, vim_item)
                --     -- Kind icons
                --     vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind],
                --         vim_item.kind) -- This concatenates the icons with the name of the item kind
                --     return vim_item
                -- end,
                -- })

            },

            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
                ["<C-e>"] = cmp.mapping.abort(),        -- close completion window
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
        })
    end,
}
