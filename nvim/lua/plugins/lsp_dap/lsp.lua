return {
    "neovim/nvim-lspconfig",

    config = function()
        -- enable lsp
        vim.lsp.enable({
            "clangd",
            "lua_ls",
            "pyright",
            "cmake",
            "verible"
        })

        -- configure diagnostic windows
        vim.diagnostic.config({
            virtual_text = false,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                border = "rounded",
                source = true,
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚 ",
                    [vim.diagnostic.severity.WARN] = "󰀪 ",
                    [vim.diagnostic.severity.INFO] = "󰋽 ",
                    [vim.diagnostic.severity.HINT] = "󰌶 ",
                },
            },
        })

        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show error Float" })

        -- LSP configuration
        vim.lsp.config('lua_ls', {
            on_init = function(client)
                if client.workspace_folders then
                    local path = client.workspace_folders[1].name
                    if
                        path ~= vim.fn.stdpath('config')
                        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                    then
                        return
                    end
                end

                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most
                        -- likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT',
                        -- Tell the language server how to find Lua modules same way as Neovim
                        -- (see `:h lua-module-load`)
                        path = {
                            'lua/?.lua',
                            'lua/?/init.lua',
                        },
                    },
                    -- Make the server aware of Neovim runtime files
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME
                            -- Depending on the usage, you might want to add additional paths
                            -- here.
                            -- '${3rd}/luv/library'
                            -- '${3rd}/busted/library'
                        }
                        -- Or pull in all of 'runtimepath'.
                        -- NOTE: this is a lot slower and will cause issues when working on
                        -- your own configuration.
                        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                        -- library = {
                        --   vim.api.nvim_get_runtime_file('', true),
                        -- }
                    }
                })
            end,
            settings = {
                Lua = {}
            }
        })

        vim.lsp.config("verible", {
            cmd = { 'verible-verilog-ls', '--rules_config_search' }
        })

        -- Keybinds
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "goto Definition" })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "goto Declaration" })

        -- Extras

        local function restart_lsp(bufnr)
            bufnr = bufnr or vim.api.nvim_get_current_buf()
            local clients = vim.lsp.get_clients({ bufnr = bufnr })

            for _, client in ipairs(clients) do
                vim.lsp.stop_client(client.id)
            end

            vim.defer_fn(function()
                vim.cmd('edit')
            end, 100)
        end

        vim.api.nvim_create_user_command('LspRestart', function()
            restart_lsp()
        end, {})

        local function lsp_status()
            local bufnr = vim.api.nvim_get_current_buf()
            local clients = vim.lsp.get_clients({ bufnr = bufnr })

            if #clients == 0 then
                print("󰅚 No LSP clients attached")
                return
            end

            print("󰒋 LSP Status for buffer " .. bufnr .. ":")
            print("─────────────────────────────────")

            for i, client in ipairs(clients) do
                print(string.format("󰌘 Client %d: %s (ID: %d)", i, client.name, client.id))
                print("  Root: " .. (client.config.root_dir or "N/A"))
                print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

                -- Check capabilities
                local caps = client.server_capabilities
                local features = {}
                if caps.completionProvider then table.insert(features, "completion") end
                if caps.hoverProvider then table.insert(features, "hover") end
                if caps.definitionProvider then table.insert(features, "definition") end
                if caps.referencesProvider then table.insert(features, "references") end
                if caps.renameProvider then table.insert(features, "rename") end
                if caps.codeActionProvider then table.insert(features, "code_action") end
                if caps.documentFormattingProvider then table.insert(features, "formatting") end

                print("  Features: " .. table.concat(features, ", "))
                print("")
            end
        end

        vim.api.nvim_create_user_command('LspStatus', lsp_status, { desc = "Show detailed LSP status" })

        local function check_lsp_capabilities()
            local bufnr = vim.api.nvim_get_current_buf()
            local clients = vim.lsp.get_clients({ bufnr = bufnr })

            if #clients == 0 then
                print("No LSP clients attached")
                return
            end

            for _, client in ipairs(clients) do
                print("Capabilities for " .. client.name .. ":")
                local caps = client.server_capabilities

                local capability_list = {
                    { "Completion",                caps.completionProvider },
                    { "Hover",                     caps.hoverProvider },
                    { "Signature Help",            caps.signatureHelpProvider },
                    { "Go to Definition",          caps.definitionProvider },
                    { "Go to Declaration",         caps.declarationProvider },
                    { "Go to Implementation",      caps.implementationProvider },
                    { "Go to Type Definition",     caps.typeDefinitionProvider },
                    { "Find References",           caps.referencesProvider },
                    { "Document Highlight",        caps.documentHighlightProvider },
                    { "Document Symbol",           caps.documentSymbolProvider },
                    { "Workspace Symbol",          caps.workspaceSymbolProvider },
                    { "Code Action",               caps.codeActionProvider },
                    { "Code Lens",                 caps.codeLensProvider },
                    { "Document Formatting",       caps.documentFormattingProvider },
                    { "Document Range Formatting", caps.documentRangeFormattingProvider },
                    { "Rename",                    caps.renameProvider },
                    { "Folding Range",             caps.foldingRangeProvider },
                    { "Selection Range",           caps.selectionRangeProvider },
                }

                for _, cap in ipairs(capability_list) do
                    local status = cap[2] and "✓" or "✗"
                    print(string.format("  %s %s", status, cap[1]))
                end
                print("")
            end
        end

        vim.api.nvim_create_user_command('LspCapabilities', check_lsp_capabilities, { desc = "Show LSP capabilities" })

        local function lsp_diagnostics_info()
            local bufnr = vim.api.nvim_get_current_buf()
            local diagnostics = vim.diagnostic.get(bufnr)

            local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

            for _, diagnostic in ipairs(diagnostics) do
                local severity = vim.diagnostic.severity[diagnostic.severity]
                counts[severity] = counts[severity] + 1
            end

            print("󰒡 Diagnostics for current buffer:")
            print("  Errors: " .. counts.ERROR)
            print("  Warnings: " .. counts.WARN)
            print("  Info: " .. counts.INFO)
            print("  Hints: " .. counts.HINT)
            print("  Total: " .. #diagnostics)
        end

        vim.api.nvim_create_user_command('LspDiagnostics', lsp_diagnostics_info, { desc = "Show LSP diagnostics count" })
    end
}
