vim.g.mapleader = "-"
vim.g.maplocalleader = "\\"

vim.go.tabstop = 8
vim.go.shiftwidth = 8
vim.go.expandtab = true
vim.go.relativenumber = true
-- vim.go.wildmode = "longest,list,full"
-- vim.go.wildmenu = true

require("config.lazy")
require("config.lsp")
require("config.maps")

if init_debug then
	require("osv").launch({ port = 8086, blocking = true })
end
