local widgets = require('dap.ui.widgets')

-- General {{{

vim.keymap.set('n', '<leader>si', ':source $MYVIMRC<cr>', {noremap=true})
vim.keymap.set('n', '<leader>qc', ':pclose<cr>', {noremap=true})

vim.keymap.set('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, {noremap=true})
vim.keymap.set('n', '<leader>lwd', vim.lsp.buf.remove_workspace_folder, {noremap=true})
vim.keymap.set('n', '<leader>lwl', function()
        local dirs = vim.lsp.buf.list_workspace_folders()
        print(vim.inspect(dirs))
end, {noremap=true})

vim.keymap.set('n', '<leader>dl', function() 
  require"osv".launch({port = 8086}) 
end, { noremap = true })

vim.keymap.set('n', '<leader>dL', function() 
  require"osv".stop() 
  print("Lua DAP stopped")
end, { noremap = true })


vim.keymap.set({'n', 'v'}, '<Leader>fdk', widgets.hover, {noremap=true})
vim.keymap.set({'n', 'v'}, '<Leader>fdp', widgets.preview, {noremap=true})
vim.keymap.set('n', '<Leader>fds', function()
        widgets.centered_float(widgets.scopes)
end, {noremap=true})



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
-- vim.keymap.set('n', '<leader>od', ':vs %:h<cr>', {noremap=true})
-- vim.keymap.set('n', '<leader>ed', ':e %:h<cr>', {noremap=true})
-- }}}
