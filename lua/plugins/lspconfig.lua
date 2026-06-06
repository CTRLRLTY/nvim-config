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

	local lspconfig = require("lspconfig")
	for server, config in pairs(servers) do
		-- passing config.capabilities to blink.cmp merges with the capabilities in your
		-- `opts[server].capabilities, if you've defined it
		config.capabilities = require("blink.cmp").get_lsp_capabilities(
			config.capabilities
		)
		lspconfig[server].setup(config)
	end
end

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },

		-- example using `opts` for defining servers
		opts = {
			servers = {
				lua_ls = {},
			},
		},
		config = function(_, opts)
			lsp_config(opts.servers)
		end,
		lazy = false,
	},
}
