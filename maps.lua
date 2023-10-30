-- General {{{
vim.keymap.set('n', '<leader>vi', ':vsplit $MYVIMRC<cr>', {noremap=true})
vim.keymap.set('n', '<leader>hi', ':split $MYVIMRC<cr>', {noremap=true})
vim.keymap.set('n', '<leader>vo', ':vsplit ' .. vim.g.init_lua .. '<cr>', {noremap=true})
vim.keymap.set('n', '<leader>ho', ':split ' .. vim.g.init_lua .. '<cr>', {noremap=true})
vim.keymap.set('n', '<leader>si', ':source $MYVIMRC<cr>', {noremap=true})

vim.keymap.set('n', '<leader>vm', ':vsplit ' .. vim.g.map_lua_config .. '<cr>', {noremap=true})
vim.keymap.set('n', '<leader>hm', ':split ' .. vim.g.map_lua_config .. '<cr>', {noremap=true})

vim.keymap.set('n', '<leader>vl', ':vsplit ' .. vim.g.native_lsp_config .. '<cr>', {noremap=true})
vim.keymap.set('n', '<leader>hl', ':split ' .. vim.g.native_lsp_config .. '<cr>', {noremap=true})

vim.keymap.set('n', '<leader>qc', ':pclose<cr>', {noremap=true})
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
