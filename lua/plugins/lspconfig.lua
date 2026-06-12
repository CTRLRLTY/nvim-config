local function format_buffer()
	require("conform").format({ async = true, lsp_fallback = true })
end

---@param bufnr integer
local function setup_lsp_keymap(bufnr)
	local builtin = require("telescope.builtin")
	local opts = { buffer = bufnr, noremap = true }

	vim.keymap.set(
		"n",
		"<leader>log",
		"<CMD>LspLog<CR>",
		vim.tbl_extend("force", opts, { desc = "Open LSP log" })
	)

	vim.keymap.set(
		{ "n", "v" },
		"<leader>ca",
		vim.lsp.buf.code_action,
		vim.tbl_extend("force", opts, { desc = "LSP action" })
	)

	vim.keymap.set(
		"n",
		"<leader>nrn",
		vim.lsp.buf.rename,
		vim.tbl_extend("force", opts, { desc = "LSP rename symbol" })
	)

	vim.keymap.set(
		"n",
		"<leader>sD",
		builtin.diagnostics,
		vim.tbl_extend("force", opts, { desc = "LSP diagnostics" })
	)
	vim.keymap.set(
		"n",
		"<leader>ss",
		builtin.lsp_document_symbols,
		vim.tbl_extend(
			"force",
			opts,
			{ desc = "LSP show document symbols" }
		)
	)
	vim.keymap.set(
		"n",
		"<leader>sS",
		builtin.lsp_workspace_symbols,
		vim.tbl_extend(
			"force",
			opts,
			{ desc = "LSP show workspace symbols" }
		)
	)
	vim.keymap.set(
		"n",
		"<leader>sr",
		builtin.lsp_references,
		vim.tbl_extend("force", opts, { desc = "LSP symbol reference" })
	)
	vim.keymap.set(
		"n",
		"<leader>sk",
		vim.lsp.buf.hover,
		vim.tbl_extend("force", opts, { desc = "LSP symbol hover" })
	)
	vim.keymap.set(
		"n",
		"<leader>sK",
		vim.lsp.buf.signature_help,
		vim.tbl_extend(
			"force",
			opts,
			{ desc = "LSP function signature" }
		)
	)
	-- vim.keymap.set('n', '<leader>sc', vim.lsp.buf.completion, opts)

	vim.keymap.set(
		"n",
		"<leader>gd",
		builtin.lsp_definitions,
		vim.tbl_extend(
			"force",
			opts,
			{ desc = "LSP symbol definition" }
		)
	)
	vim.keymap.set(
		"n",
		"<leader>gtd",
		builtin.lsp_type_definitions,
		vim.tbl_extend(
			"force",
			opts,
			{ desc = "LSP symbol type definition" }
		)
	)
	vim.keymap.set(
		"n",
		"<leader>gi",
		builtin.lsp_implementations,
		vim.tbl_extend(
			"force",
			opts,
			{ desc = "LSP symbol implementations" }
		)
	)

	vim.keymap.set(
		"n",
		"<leader>la",
		vim.lsp.buf.add_workspace_folder,
		vim.tbl_extend("force", opts, { desc = "LSP add workspace" })
	)
	vim.keymap.set(
		"n",
		"<leader>lr",
		vim.lsp.buf.remove_workspace_folder,
		vim.tbl_extend("force", opts, { desc = "LSP remove workspace" })
	)

	vim.keymap.set(
		"n",
		"<leader>cfmt",
		format_buffer,
		vim.tbl_extend("force", opts, { desc = "LSP format" })
	)
end

---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach_jedi(client, bufnr)
	setup_lsp_keymap(bufnr)
end

local function lsp_config(servers)
	-- vim.diagnostic.config({
	-- 	virtual_text = true,
	-- 	float = {
	-- 		focusable = false,
	-- 		style = "minimal",
	-- 		border = "rounded",
	-- 		source = true,
	-- 		header = "",
	-- 		prefix = "",
	-- 	},
	-- })

	vim.o.updatetime = 500

	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			vim.diagnostic.open_float(nil, { focus = false })
		end,
	})

	for server, config in pairs(servers) do
		-- passing config.capabilities to blink.cmp merges with the capabilities in your
		-- `opts[server].capabilities, if you've defined it
		config.capabilities = require("blink.cmp").get_lsp_capabilities(
			config.capabilities
		)

		vim.lsp.config(server, config)
	end
end

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },

		-- example using `opts` for defining servers
		opts = {
			servers = {
				lua_ls = {
					on_attach = function(_, bufnr)
						setup_lsp_keymap(bufnr)
					end,
				},
				jedi_language_server = {
					on_attach = on_attach_jedi,
				},
			},
		},
		config = function(_, opts)
			lsp_config(opts.servers)
		end,
		lazy = false,
	},
}
