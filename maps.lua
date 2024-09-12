-- General {{{

vim.keymap.set('n', '<leader>si', ':source $MYVIMRC<cr>', {noremap=true})
vim.keymap.set('n', '<leader>fim', ':Telescope find_files search_dirs={vim.fs.dirname(vim.env.MYVIMRC)}<cr>')


vim.keymap.set('n', '<leader>qc', ':pclose<cr>', {noremap=true})

local builtin = require('telescope.builtin')
local tabs = require('telescope-tabs')
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
vim.keymap.set('n', '<leader>fkn', builtin.keymaps, {noremap=true})
vim.keymap.set('n', '<leader>fll', builtin.loclist, {noremap=true})
vim.keymap.set('n', '<leader>fj', builtin.jumplist, {noremap=true})
vim.keymap.set('n', '<leader>fac', builtin.autocommands, {noremap=true})
vim.keymap.set('n', '<leader>fs', builtin.grep_string, {noremap=true})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {noremap=true})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {noremap=true})

vim.keymap.set('n', '<leader>yfn', function()
        local line = vim.fn.line(".")
        local cmd = vim.fn.expand('%') .. ":" .. line
        vim.fn.setreg("", cmd) 
end, {noremap=true})
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
