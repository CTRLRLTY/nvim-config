vim.g.mapleader = "-"
vim.g.maplocalleader = "\\"

vim.go.tabstop = 8
vim.go.shiftwidth = 8
vim.go.expandtab = true
vim.go.wildmode = "longest,list,full"
vim.go.wildmenu = true

require('config.lazy')
require('config.lsp')
require('config.maps')

if init_debug then
        require"osv".launch({port=8086, blocking=true})
end

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
        group = vim.api.nvim_create_augroup('NumberToggle', {clear=true}), 
})
