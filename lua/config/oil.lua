local M = {}

function M.open_cwd()
	lsp = require("config.lsp")
	require("oil").open_float(vim.fn.expand("%:p:h"))
end

function M.open_workspace()
	lsp = require("config.lsp")
	require("oil").open_float(lsp.active_workspace())
end

return M
