return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "mfussenegger/nvim-dap-python"
    },
    config = function ()
        local dap = require("dap")
        local dapui = require("dapui")
        
        require("dapui").setup()

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        -- setup debugger for c
        dap.adapters.cppdbg = {
            id = 'cppdbg',
            type = "executable",
            command = "/opt/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
        }

        dap.configurations.cpp = {
            {
                name = "Run executable (GDB)",
                type = "cppdbg",
                request = "launch",
                program = function ()
                    local path = vim.fn.input({
                        prompt = 'Path to executable: ',
                        default = vim.fn.getcwd() .. '/',
                        completion = 'file'
                    })
                    return (path and path ~= '') and path or dap.ABORT
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                setupCommands = {
                    {
                        text = '-enable-pretty-printing',
                        description = 'enable pretty printing',
                        ignoreFailures = false
                    },
                },
            },
            {
                name = 'Attach to gdbserver :1233',
                type = 'cppdbg',
                request = 'launch',
                MIMode = 'gdb',
                midebuggerServerAddress = 'localhost:1233',
                miDebuggerPath = '/usr/bin/gdb',
                cwd = '${workspaceFolder}',
                program = function ()
                    local path = vim.fn.input({
                        prompt = 'Path to executable: ',
                        default = vim.fn.getcwd() .. '/',
                        completion = 'file'
                    })
                    return (path and path ~= '') and path or dap.ABORT
                end,

            },
            {
                name = 'Run executable with arguments (GDB)',
                type = 'cppdbg',
                request = 'launch',
                -- This requires special handling of 'run_last', see
                -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
                program = function()
                    local path = vim.fn.input({
                        prompt = 'Path to executable: ',
                        default = vim.fn.getcwd() .. '/',
                        completion = 'file',
                    })

                    return (path and path ~= '') and path or dap.ABORT
                end,
                args = function()
                    local args_str = vim.fn.input({
                        prompt = 'Arguments: ',
                    })
                    return vim.split(args_str, ' +')
                end,
                cwd = '${workspaceFolder}',
                setupCommands = {
                    {
                        text = '-enable-pretty-printing',
                        description = 'enable pretty printing',
                        ignoreFailures = false
                    },
                },
            },
            {
                name = 'Attach to gdbserver :1233',
                type = 'cppdbg',
                request = 'launch',
                MIMode = 'gdb',
                midebuggerServerAddress = 'localhost:1233',
                miDebuggerPath = '/usr/bin/gdb',
                cwd = '${workspaceFolder}',
                program = function ()
                    local path = vim.fn.input({
                        prompt = 'Path to executable: ',
                        default = vim.fn.getcwd() .. '/',
                        completion = 'file'
                    })
                    return (path and path ~= '') and path or dap.ABORT
                end,

            },

        }
        dap.configurations.c = dap.configurations.cpp
        dap.configurations.asm = dap.configurations.cpp
        ---setup for python---
        require('dap-python').setup('~/.venv/debugpy/bin/python')

        vim.keymap.set('n', "<Leader>db", dap.toggle_breakpoint, {desc = "Toggle Breakpoint"})
        vim.keymap.set('n', "<leader>dc", dap.continue, {desc = "continue debugging"})
        vim.keymap.set('n', "<leader>du", dapui.toggle, {desc = "Dap UI"})
        vim.keymap.set('n', "<leader>de", dapui.eval, {desc = "Eval"})
    end,
}
