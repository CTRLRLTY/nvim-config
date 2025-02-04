if init_debug then
        require"osv".launch({port=8086, blocking=true})
end

require('telescope').load_extension('telescope-tabs')
require('telescope').load_extension('dap')

local dap = require("dap")

dap.configurations = {}

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

require('dap-go').setup({
        dap_configurations = {
                {
                       type = "go",
                       name = "Debug Project" ,
                       request = "launch",
                       program = dap_go_program
                }
        },
})

dap.configurations.lua = { 
        { 
                type = 'nlua', 
                request = 'attach',
                name = "Attach to running Neovim instance",
        }
}

dap.adapters.nlua = function(callback, config)
        callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
end

dap.adapters.cmake = {
        type = "pipe",
        pipe = "${pipe}",
        executable = {
                command = "cmake",
                args = {"--debugger", "--debugger-pipe", "${pipe}", "./build"}
        }
}

dap.configurations.cmake = {
        {
                name = "Build",
                type = "cmake",
                request = "launch",
        }
}

-- require('dap.ext.vscode').load_launchjs()

require("dapui").setup()

-- gruvbox specific
vim.api.nvim_create_autocmd("vimenter", {
        pattern = "*",
        command = "colorscheme gruvbox",
        nested = true
})

-- automatic number and relativenumber
local group_numbertoggle = vim.api.nvim_create_augroup('NumberToggle', {clear=true})

vim.api.nvim_create_autocmd("ModeChanged", {
        callback = function(ev)
                if not vim.o.number then
                        return
                end

                if vim.fn.mode() == 'v' then
                        vim.o.relativenumber = true
                else
                        vim.o.relativenumber = false
                end
        end,
        group = group_numbertoggle, 
})
