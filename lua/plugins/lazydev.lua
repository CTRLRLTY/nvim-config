---@param ctx blink.cmp.DrawItemContext
---@return string
local function get_source_name(ctx)
	if ctx.source_name == "LSP" then
		---@diagnostic disable-next-line: undefined-field
		local client_name = (ctx.item and ctx.item.client_name)
			or ctx.client_name
		if type(client_name) == "string" and client_name ~= "" then
			return client_name
		end
	end
	return ctx.source_name
end

return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},
	{ -- OSV
		"jbyuki/one-small-step-for-vimkind",
		lazy = true,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		dependencies = { "rcarriga/nvim-dap-ui" },
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{
					path = "${3rd}/luv/library",
					words = { "vim%.uv" },
				},
			},
		},
	},
	{ -- optional blink completion source for require statements and module annotations
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },

		-- use a release tag to download pre-built binaries
		version = "1.*",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			completion = {
				menu = {
					draw = {
						columns = {
							{ "kind_icon" },
							{
								"label",
								"label_description",
								gap = 1,
							},
							{ "source_name" },
						},
						components = {
							source_name = {
								text = get_source_name,
								highlight = "BlinkCmpSource",
							},
						},
					},
				},
			},
			sources = {
				-- add lazydev to your completion providers
				default = {
					"lazydev",
					"lsp",
					"path",
					"snippets",
					"buffer",
				},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
					lsp = {
						name = "LSP",
						score_offset = 80,
					},
					snippets = {
						name = "Snippets",
						score_offset = 50,
					},
					buffer = {
						name = "Buffer",
						score_offset = 20,
					},
					path = {
						name = "Path",
						score_offset = 10,
					},
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	},
}
