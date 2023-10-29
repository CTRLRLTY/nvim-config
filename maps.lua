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
-- }}}
