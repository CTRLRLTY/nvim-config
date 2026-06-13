local M = {}

function M.workspaces()
	local dirs = vim.lsp.buf.list_workspace_folders()
	local uniq = vim.fn.uniq(dirs)

	return uniq
end

function M.active_workspace()
	local folders = M.workspaces()

	if #folders >= 1 then
		return folders[1]
	end

	return vim.fn.expand("%:p:h")
end

local ag_lsp_config = vim.api.nvim_create_augroup("UserLspConfig", {})

local function format_buffer()
	require("conform").format({ async = true, lsp_fallback = true })
end

vim.api.nvim_create_autocmd("BufWrite", {
	group = ag_lsp_config,
	callback = function(ev)
		local has_lsp = #vim.lsp.get_clients({ bufnr = ev.buf }) > 0

		if not has_lsp then
			return false
		end

		format_buffer()
	end,
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = ag_lsp_config,
	callback = function(ev)
		local winid = vim.api.nvim_get_current_win()

		vim.wo[winid][0].number = true

		local wrkspace = vim.lsp.buf.list_workspace_folders()[1]

		if not wrkspace == nil then
			vim.uv.chdir(wrkspace)
		end
	end,
})

return M
