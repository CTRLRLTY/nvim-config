return {
        {
                'mfussenegger/nvim-dap',
                tag = '0.10.0',
                config = function()
                        local dap = require("dap")

                        dap.configurations = {}
                        dap.configurations.lua = {
                                {
                                        type = 'nlua',
                                        request = 'attach',
                                        name = "Attach to running Neovim instance",
                                }
                        }

                        dap.configurations.python = {
                                {
                                        type = "python",
                                        request = 'launch',
                                        name = "current file",
                                        program = "${file}",
                                },
                                {
                                        type = "python",
                                        request = 'launch',
                                        name = "example jary",
                                        program = "${file}",
                                        args = { "./example.jary" },
                                }

                        }

                        dap.configurations.cmake = {
                                {
                                        name = "Build",
                                        type = "cmake",
                                        request = "launch",
                                }
                        }


                        dap.adapters.nlua = function(callback, config)
                                callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
                        end

                        dap.adapters.python = {
                                type = "executable",
                                command = os.getenv('HOME') .. '/pyenv/bin/python',
                                args = { '-m', 'debugpy.adapter' },
                        }

                        dap.adapters.cmake = {
                                type = "pipe",
                                pipe = "${pipe}",
                                executable = {
                                        command = "cmake",
                                        args = { "--debugger", "--debugger-pipe", "${pipe}", "./build" }
                                }
                        }

                        local opts = { noremap = true }

                        dap.listeners.after["launch"]["__personal__"] = function(s, b)
                                -- local buf = vim.api.nvim_get_current_buf()

                                vim.print("Setting DAP Maps")
                                vim.keymap.set('n', 'dc', dap.continue, opts)
                                vim.keymap.set('n', 'ds', dap.step_over, opts)
                                vim.keymap.set('n', 'dz', dap.disconnect, opts)
                                vim.keymap.set('n', 'di', dap.step_into, opts)
                                vim.keymap.set('n', 'df', dap.step_out, opts)
                                vim.keymap.set('n', 'db', dap.toggle_breakpoint, opts)
                                vim.keymap.set('n', 'dB', dap.set_breakpoint, opts)
                                vim.keymap.set('n', 'dro', dap.repl.open, opts)
                                vim.keymap.set('n', 'drl', dap.run_last, opts)
                        end

                        dap.listeners.after["event_terminated"]["__personal__"] = function(s, b)
                                -- local buf = vim.api.nvim_get_current_buf()
                                local opts = { noremap = true }

                                vim.print("Deleting DAP Maps")
                                vim.keymap.del('n', 'dc', opts)
                                vim.keymap.del('n', 'ds', opts)
                                vim.keymap.del('n', 'dz', opts)
                                vim.keymap.del('n', 'di', opts)
                                vim.keymap.del('n', 'df', opts)
                                vim.keymap.del('n', 'db', opts)
                                vim.keymap.del('n', 'dB', opts)
                                vim.keymap.del('n', 'dro', opts)
                                vim.keymap.del('n', 'drl', opts)
                        end


                        vim.api.nvim_create_autocmd('FileType', {
                                callback = function(ev)
                                        local ftype = vim.bo.filetype

                                        if dap.configurations[ftype] == nil then
                                                return
                                        end

                                        vim.keymap.set('n', '<Leader>dc', dap.continue, opts)
                                        vim.keymap.set('n', '<Leader>ds', dap.step_over, opts)
                                        vim.keymap.set('n', '<Leader>dz', dap.disconnect, opts)
                                        vim.keymap.set('n', '<Leader>di', dap.step_into, opts)
                                        vim.keymap.set('n', '<Leader>df', dap.step_out, opts)
                                        vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint, opts)
                                        vim.keymap.set('n', '<Leader>dbc', function()
                                                cond = vim.fn.input("breakpoint condition: ")
                                                dap.set_breakpoint(cond)
                                        end, opts)
                                        vim.keymap.set('n', '<Leader>dB', dap.set_breakpoint, opts)
                                        vim.keymap.set('n', '<Leader>dro', dap.repl.open, opts)
                                        vim.keymap.set('n', '<Leader>drl', dap.run_last, opts)
                                end,
                                group = vim.api.nvim_create_augroup('DAP mappings', {}),
                        })
                end,
                dependencies = { 'leoluz/nvim-dap-go' }
        },
}
