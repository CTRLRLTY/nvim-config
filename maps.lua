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
