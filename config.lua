require('telescope').load_extension('telescope-tabs')


-- options
vim.o.colorcolumn = "80"


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
