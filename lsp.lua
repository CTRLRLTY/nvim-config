-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('FileType', {
        pattern = 'c',
        callback = function(ev)
                -- comment on highlight
                vim.keymap.set('n', '<leader>k', function()
                        local commented = false
                        local startline = vim.fn.line("'<")
                        local endline = vim.fn.line("'>")
                        for i = startline, endline, 1 do
                                local prefix = vim.api.nvim_buf_get_text(ev.buf, i-1, 0, i-1, 2, {})    
                                if prefix[1] == "//" then
                                        commented = true 
                                        break
                                else
                                        commented = false
                                end
                        end
                        if commented then
                                vim.api.nvim_command(startline .. ',' .. endline .. 's/^\\/\\/ /')
                        else
                                vim.api.nvim_command(startline .. ',' .. endline .. 's/^/\\/\\/ /')
                        end

                        vim.api.nvim_command("nohlsearch")
                        vim.api.nvim_command("norm! ``") -- back to original pos
                end, { noremap = true, buffer = ev.buf})

                vim.lsp.start({
                        name = 'clangd',
                        cmd = {'clangd'},
                        root_dir = vim.fs.dirname(vim.fs.find({'.clangd', '.git'}, { upward = true })[1]),
                })
        end,
        group = vim.api.nvim_create_augroup('ClangdLspConfig', {clear=true}),
})

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
