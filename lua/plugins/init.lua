function dap_go_program()
        local routine = function(dap_run_co) 
                require("telescope.builtin").git_files({
                        prompt_title = "Select File to Debug",
                        file_ignore_patterns = {"([^g][^o])$"},
                        attach_mappings = function(_, map) 
                                local actions = require('telescope.actions')
                                local state = require('telescope.actions.state')

                                actions.select_default:replace(function(prompt_bufnr)
                                        local entry = state.get_selected_entry()
                                        local file_path = entry.path or entry.filename

                                        vim.print(file_path)
                                        actions.close(prompt_bufnr)
                                        coroutine.resume(dap_run_co, file_path)
                                end)

                                return true
                        end})
        end

	return coroutine.create(routine)
end

return {
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		'LukasPietzschmann/telescope-tabs',
                config = function()
                        require('telescope').load_extension('telescope-tabs')
                end,
		dependencies = { 'nvim-telescope/telescope.nvim' },
	},
	{
                'nvim-telescope/telescope-dap.nvim',
                config = function()
                        require('telescope').load_extension('dap')
                end,
                dependencies = { 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap' }
        },
        {
                'mfussenegger/nvim-dap', tag = '0.10.0',
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
                                        args = {"./example.jary"},
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
                                        args = {"--debugger", "--debugger-pipe", "${pipe}", "./build"}
                                }
                        }
                end,
                dependencies = { 'leoluz/nvim-dap-go' }
        },
        { 
                "ellisonleao/gruvbox.nvim", priority = 1000,
                config = function()
                        require("gruvbox").setup()
                        vim.go.background = "dark"
                        vim.cmd("colorscheme gruvbox")

                        vim.api.nvim_create_autocmd("vimenter", {
                                pattern = "*",
                                command = "colorscheme gruvbox",
                                nested = true
                        })
                end,
                lazy = false
        },
        {
                'nvim-treesitter/nvim-treesitter', tag = 'v0.9.3',
                priority = 1000,
                opts = { ensure_installed = { "go", "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" } },
                lazy = false
        },
        {
                'leoluz/nvim-dap-go',
                dap_configurations = {
                        {
                                type = "go",
                                name = "Debug Project",
                                request = "launch",
                                program = dap_go_program
                        }
                },
                dependencies = { 'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter' },
        },
        { 
                "rcarriga/nvim-dap-ui", tag = 'v4.0.0',
                config = function()
                        -- require('dap.ext.vscode').load_launchjs()
                        -- require("lazydev").setup({
                                --         library = { "nvim-dap-ui" },
                                -- })
                                require("dapui").setup()
                        end,
                        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} 
                },
        }
