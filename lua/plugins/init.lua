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
		dependencies = { 'nvim-lua/plenary.nvim' },
                config = function(_, opts)
                        require('telescope').setup(opts)
                        local builtin = require('telescope.builtin')

                        vim.keymap.set('n', '<leader>fF', function() 
                                local utils = require("telescope.utils")
                                local root = vim.lsp.buf.list_workspace_folders()[1]

                                builtin.find_files({cwd=root, no_ignore=true}) 
                        end, {noremap=true})

                        vim.keymap.set('n', '<leader>fim', ':Telescope find_files search_dirs={vim.fs.dirname(vim.env.MYVIMRC)}<cr>')
                        vim.keymap.set('n', '<leader>ff', function()
                                local utils = require("telescope.utils")
                                local root = vim.lsp.buf.list_workspace_folders()[1]

                                builtin.find_files({cwd=root})
                        end, {noremap=true})

                        vim.keymap.set('n', '<leader>fgf', builtin.git_files, {noremap=true})
                        vim.keymap.set('n', '<leader>flg', builtin.live_grep, {noremap=true})
                        vim.keymap.set('n', '<leader>fm', builtin.marks, {noremap=true})
                        vim.keymap.set('n', '<leader>fM', function() builtin.man_pages({sections = {"ALL"}}) end, {noremap=true})
                        vim.keymap.set('n', '<leader>fr', builtin.registers, {noremap=true})
                        vim.keymap.set('n', '<leader>fzf', builtin.current_buffer_fuzzy_find, {noremap=true})
                        vim.keymap.set('n', '<leader>fc', builtin.commands, {noremap=true})
                        vim.keymap.set('n', '<leader>fC', builtin.command_history, {noremap=true})
                        vim.keymap.set('n', '<leader>fS', builtin.search_history, {noremap=true})
                        vim.keymap.set('n', '<leader>fvo', builtin.vim_options, {noremap=true})
                        vim.keymap.set('n', '<leader>fvk', builtin.keymaps, {noremap=true})
                        vim.keymap.set('n', '<leader>fll', builtin.loclist, {noremap=true})
                        vim.keymap.set('n', '<leader>fj', builtin.jumplist, {noremap=true})
                        vim.keymap.set('n', '<leader>fac', builtin.autocommands, {noremap=true})
                        vim.keymap.set('n', '<leader>fs', builtin.grep_string, {noremap=true})
                        vim.keymap.set('n', '<leader>fb', builtin.buffers, {noremap=true})
                        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {noremap=true})
                end,
                keys = {
                        {'<leader>fgf', desc="Find git files"},
                        {'<leader>flg', desc="Live grep"},
                        {'<leader>fm', desc="Find marks"},
                        {'<leader>fM', desc="Find man page"},
                        {'<leader>fr', desc="Find registers"},
                        {'<leader>fzf', desc="Current buffer fuzzy find"},
                        {'<leader>fc', desc="Find commands"},
                        {'<leader>fS', desc="Find search history"},
                        {'<leader>fvo', desc="Find vim options"},
                        {'<leader>fvk', desc="Find keymaps"},
                        {'<leader>fll', desc="Find location list"},
                        {'<leader>fj', desc="Find jump list"},
                        {'<leader>fac', desc="Find autocommands"},
                        {'<leader>fs', desc="Grep string"},
                        {'<leader>fb', desc="Find buffers"},
                        {'<leader>fh', desc="Find help tags"},
                }
	},
	{
		'LukasPietzschmann/telescope-tabs',
                config = function()
                        require('telescope').load_extension('telescope-tabs')
                        local tabs = require('telescope-tabs')
                        vim.keymap.set('n', '<leader>ft', tabs.list_tabs, {noremap=true})
                end,
		dependencies = { 'nvim-telescope/telescope.nvim' },
	},
	{
                'nvim-telescope/telescope-dap.nvim',
                config = function()
                        require('telescope').load_extension('dap')
                        local teledap = require('telescope').extensions.dap
                        vim.keymap.set('n', '<leader>fdc', teledap.configurations, {noremap=true})
                        vim.keymap.set('n', '<leader>fdb', teledap.list_breakpoints, {noremap=true})
                        vim.keymap.set('n', '<leader>fdv', teledap.variables, {noremap=true})
                end,
                keys = {
                        {'<leader>fdf', '<cmd>Telescope dap frames', desc="Find DAP frames"}
                },
                dependencies = { 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap' }
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
                opts = {
                        dap_configurations = {
                                {
                                        type = "go",
                                        name = "Debug Project",
                                        request = "launch",
                                        program = dap_go_program
                                }
                        },
                },
                dependencies = { 'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter' },
        },
        { 
                "rcarriga/nvim-dap-ui", tag = 'v4.0.0',
                config = function()
                        -- require('dap.ext.vscode').load_launchjs()
                                require('dapui').setup()
                                dapui = require('dapui')
                                vim.keymap.set('n', '<Leader>dt', dapui.toggle)
                        end,
                dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} 
        },
        {
                "ahmedkhalf/project.nvim",
                dependencies = { 'nvim-telescope/telescope.nvim' },
                opts = {
                        sync_root_with_cwd = true,
                        respect_buf_cwd = true,
                        update_focused_file = {
                                enable = true,
                                update_root = true
                        },
                },
                config = function(_, opts)
                        require('project_nvim').setup(opts)
                        require('telescope').load_extension('projects')
                        projects = require('telescope').extensions.projects
                        vim.keymap.set('n', '<Leader>fp', projects.projects)
                end
        },
        {
                'stevearc/oil.nvim',
                ---@module 'oil'
                ---@type oil.SetupOpts
                config=true,
                -- Optional dependencies
                dependencies = { { "echasnovski/mini.icons", config = true }, 'nvim-telescope/telescope.nvim' },
                keys = {
                        {"<leader>od", function() require('oil').open_float() end,desc = "Open parent directory"}
                },
                -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
                lazy = false,
        }
}
