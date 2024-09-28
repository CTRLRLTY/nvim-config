local teledap = require('telescope').extensions.dap
local builtin = require('telescope.builtin')
local tabs = require('telescope-tabs')
local widgets = require('dap.ui.widgets')
local dap = require('dap')
local dapui = require('dapui')

-- General {{{

vim.keymap.set('n', '<leader>si', ':source $MYVIMRC<cr>', {noremap=true})
vim.keymap.set('n', '<leader>fim', ':Telescope find_files search_dirs={vim.fs.dirname(vim.env.MYVIMRC)}<cr>')

vim.keymap.set('n', '<leader>qc', ':pclose<cr>', {noremap=true})

vim.keymap.set('n', '<leader>ft', tabs.list_tabs, {noremap=true})
vim.keymap.set('n', '<leader>ff', builtin.find_files, {noremap=true})
vim.keymap.set('n', '<leader>fF', function() builtin.find_files({no_ignore=true}) end, {noremap=true})
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

vim.keymap.set('n', '<Leader>dt', dapui.toggle, opts)
vim.keymap.set('n', '<leader>fdf', teledap.frames, {noremap=true})
vim.keymap.set('n', '<leader>fdc', teledap.configurations, {noremap=true})
vim.keymap.set('n', '<leader>fdb', teledap.list_breakpoints, {noremap=true})
vim.keymap.set('n', '<leader>fdv', teledap.variables, {noremap=true})
vim.keymap.set({'n', 'v'}, '<Leader>fdk', widgets.hover, {noremap=true})
vim.keymap.set({'n', 'v'}, '<Leader>fdp', widgets.preview, {noremap=true})
vim.keymap.set('n', '<Leader>fds', function()
        widgets.centered_float(widgets.scopes)
end, {noremap=true})

dap.listeners.after["launch"]["__personal__"] = function(s, b)
        -- local buf = vim.api.nvim_get_current_buf()
        local opts = { noremap = true }

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


vim.keymap.set('n', '<leader>yfn', function()
        local line = vim.fn.line(".")
        local cmd = vim.fn.expand('%') .. ":" .. line
        vim.fn.setreg("", cmd) 
end, {noremap=true})


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
                vim.keymap.set('n', '<Leader>dB', dap.set_breakpoint, opts)
                vim.keymap.set('n', '<Leader>dro', dap.repl.open, opts)
                vim.keymap.set('n', '<Leader>drl', dap.run_last, opts)
        end,
        group = vim.api.nvim_create_augroup('DAP mappings', {}),
})

-- }}}
-- Window {{{
        ---- Move current buffer to the previous tab
vim.keymap.set('n', '<leader>th', function() 
        local currenttab = vim.fn.tabpagenr()
        local totaltabs = vim.fn.tabpagenr('$')

        if currenttab == 1 then
                print("No previous tab")
                return
        end

        local currentbuf = vim.api.nvim_get_current_buf() 
        vim.cmd("quit")
        vim.cmd("tabprevious")
        vim.cmd("sb" .. currentbuf)
end, {noremap=true})

---- Move current buffer to the next tab
vim.keymap.set('n', '<leader>tl', function()
        local currenttab = vim.fn.tabpagenr()
        local totaltabs = vim.fn.tabpagenr('$')

        if currenttab == totaltabs then
                print("No next tab")
                return
        end

        local currentbuf = vim.api.nvim_get_current_buf()
        vim.cmd("quit")
        vim.cmd("tabnext")
        vim.cmd("sb" .. currentbuf)
end, {noremap=true})

-- Stack window to right
vim.keymap.set('n', '<leader>wl', function()
        local currentwin = vim.api.nvim_get_current_win()
        local currentbuf = vim.api.nvim_get_current_buf()

        vim.cmd('wincmd l')

        local targetwin = vim.api.nvim_get_current_win()  

        if targetwin == currentwin then
                print("No right window")
                return
        end

        vim.api.nvim_win_close(currentwin, false)
        vim.cmd("sb" .. currentbuf)
end, {noremap=true})

-- Stack window to left
vim.keymap.set('n', '<leader>wh', function()
        local currentwin = vim.api.nvim_get_current_win()
        local currentbuf = vim.api.nvim_get_current_buf()

        vim.cmd('wincmd h')

        local targetwin = vim.api.nvim_get_current_win()  

        if targetwin == currentwin then
                print("No left window")
                return
        end

        vim.api.nvim_win_close(currentwin, false)
        vim.cmd("sb" .. currentbuf)
end, {noremap=true})

---- open directory listing
vim.keymap.set('n', '<leader>od', ':vs %:h<cr>', {noremap=true})
vim.keymap.set('n', '<leader>ed', ':e %:h<cr>', {noremap=true})
-- }}}
