local ag_lsp_config = vim.api.nvim_create_augroup('UserLspConfig', {})

vim.api.nvim_create_autocmd('FileType', {
        pattern = {'c', 'cpp'},
        callback = function(ev)
                vim.lsp.start({
                        name = 'clangd',
                        cmd = {'clangd'},
                        root_dir = vim.fs.dirname(vim.fs.find({'.clangd', '.git'}, { upward = true })[1]),
                })

                vim.cmd("set cc=80")
        end,
        group = vim.api.nvim_create_augroup('ClangdLspConfig', {}),
})

vim.api.nvim_create_autocmd('FileType', {
        pattern = {'go', 'gowork', 'gomod', 'gotmpl'},
        callback = function(ev)
                vim.lsp.start({
                        name = 'gopls',
                        cmd = {'gopls'},
                        root_dir = vim.fs.dirname(vim.fs.find({'go.work', 'go.mod', '.git'}, { upward = true })[1]),
                })

                vim.cmd("set cc=80")
        end,
        group = vim.api.nvim_create_augroup('GoLspConfig', {}),
})

vim.api.nvim_create_autocmd('FileType', {
        pattern = 'javascript',
        group = vim.api.nvim_create_augroup('QuickLintJS', {}),
        callback = function(ev) 
                vim.lsp.start({
                        name = 'deno',
                        cmd = {'deno', 'lsp'},
                        root_dir = vim.fs.dirname(vim.fs.find({'package.json', '.git'}, { upward = true })[1]),
                })
        end,
})


vim.api.nvim_create_autocmd('BufEnter', {
        group = ag_lsp_config,
        callback = function(ev)
                if vim.o.filetype == "c" or vim.o.filetype == "cpp" then
                        vim.wo.colorcolumn = "80"
                else
                        vim.wo.colorcolumn = ""
                end
        end
})

vim.api.nvim_create_autocmd('BufWrite', {
        group = ag_lsp_config,
        callback = function(ev)
                local has_lsp = #vim.lsp.get_clients({bufnr = ev.buf}) > 0

                if not has_lsp then
                        return false
                end

                vim.lsp.buf.format()
        end
})
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
        group = ag_lsp_config,
        callback = function(ev)
                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf, noremap = true }

                local winid = vim.api.nvim_get_current_win()

                vim.wo[winid][0].number = true

                local builtin = require('telescope.builtin')

                vim.keymap.set('n', '<leader>log', ':lua vim.cmd("tabe" .. vim.lsp.get_log_path())<CR>', opts)
                

                vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)

                vim.keymap.set('n', '<leader>nrn', vim.lsp.buf.rename, opts)

                vim.keymap.set('n', '<leader>sD', builtin.diagnostics, opts)
                vim.keymap.set('n', '<leader>ss', builtin.lsp_document_symbols, opts)
                vim.keymap.set('n', '<leader>sS', builtin.lsp_workspace_symbols, opts)
                vim.keymap.set('n', '<leader>sr', builtin.lsp_references, opts)
                vim.keymap.set('n', '<leader>sk', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', '<leader>sK', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<leader>sc', vim.lsp.buf.completion, opts)

                vim.keymap.set('n', '<leader>gd', builtin.lsp_definitions, opts)
                vim.keymap.set('n', '<leader>gtd', builtin.lsp_type_definitions, opts)
                vim.keymap.set('n', '<leader>gi', builtin.lsp_implementations, opts)

                vim.keymap.set('n', '<leader><space>wa', vim.lsp.buf.add_workspace_folder, opts)
                vim.keymap.set('n', '<leader><space>wr', vim.lsp.buf.remove_workspace_folder, opts)

                vim.keymap.set('n', '<leader><space>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)


                vim.keymap.set('n', '<leader>cfmt', function()
                        vim.lsp.buf.format { async = true }
                end, opts)
        end,
})
