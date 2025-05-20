local ag_lsp_config = vim.api.nvim_create_augroup('UserLspConfig', {})

vim.api.nvim_create_autocmd('BufEnter', {
        group = ag_lsp_config,
        callback = function(ev)
                local has_lsp = #vim.lsp.get_clients({ bufnr = ev.buf }) > 0

                if not has_lsp then
                        vim.wo.colorcolumn = "80"
                else
                        vim.wo.colorcolumn = ""
                end
        end
})

vim.api.nvim_create_autocmd('BufWrite', {
        group = ag_lsp_config,
        callback = function(ev)
                local has_lsp = #vim.lsp.get_clients({ bufnr = ev.buf }) > 0

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

                wrkspace = vim.lsp.buf.list_workspace_folders()[1]

                if not wrkspace == nil then
                        vim.uv.chdir(wrkspace)
                else
                        print("LSP: no workspace found")
                end

                -- vim.keymap.set('n', '<leader>log', ':lua vim.cmd("tabe" .. vim.lsp.get_log_path())<CR>', vim.tbl_merge(opts, {desc = ""}))
                vim.keymap.set('n', '<leader>log', '<CMD>LspLog<CR>',
                        vim.tbl_extend("force", opts, { desc = "Open LSP log" }))

                vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action,
                        vim.tbl_extend('force', opts, { desc = "LSP action" }))

                vim.keymap.set('n', '<leader>nrn', vim.lsp.buf.rename,
                        vim.tbl_extend('force', opts, { desc = "LSP rename symbol" }))

                vim.keymap.set('n', '<leader>sD', builtin.diagnostics,
                        vim.tbl_extend('force', opts, { desc = "LSP diagnostics" }))
                vim.keymap.set('n', '<leader>ss', builtin.lsp_document_symbols,
                        vim.tbl_extend('force', opts, { desc = "LSP show document symbols" }))
                vim.keymap.set('n', '<leader>sS', builtin.lsp_workspace_symbols,
                        vim.tbl_extend('force', opts, { desc = "LSP show workspace symbols" }))
                vim.keymap.set('n', '<leader>sr', builtin.lsp_references,
                        vim.tbl_extend('force', opts, { desc = "LSP symbol reference" }))
                vim.keymap.set('n', '<leader>sk', vim.lsp.buf.hover,
                        vim.tbl_extend('force', opts, { desc = "LSP symbol hover" }))
                vim.keymap.set('n', '<leader>sK', vim.lsp.buf.signature_help,
                        vim.tbl_extend('force', opts, { desc = "LSP function signature" }))
                -- vim.keymap.set('n', '<leader>sc', vim.lsp.buf.completion, opts)

                vim.keymap.set('n', '<leader>gd', builtin.lsp_definitions,
                        vim.tbl_extend('force', opts, { desc = "LSP symbol definition" }))
                vim.keymap.set('n', '<leader>gtd', builtin.lsp_type_definitions,
                        vim.tbl_extend('force', opts, { desc = "LSP symbol type definition" }))
                vim.keymap.set('n', '<leader>gi', builtin.lsp_implementations,
                        vim.tbl_extend('force', opts, { desc = "LSP symbol implementations" }))

                vim.keymap.set('n', '<leader>la', vim.lsp.buf.add_workspace_folder,
                        vim.tbl_extend('force', opts, { desc = "LSP add workspace" }))
                vim.keymap.set('n', '<leader>lr', vim.lsp.buf.remove_workspace_folder,
                        vim.tbl_extend('force', opts, { desc = "LSP remove workspace" }))

                vim.keymap.set('n', '<leader>lww', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, vim.tbl_extend('force', opts, { desc = "LSP list workspaces" }))


                vim.keymap.set('n', '<leader>cfmt', function()
                        vim.lsp.buf.format { async = true }
                end, vim.tbl_extend('force', opts, { desc = "LSP format" }))
        end,
})
