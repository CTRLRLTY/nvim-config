return {
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			theme = "gruvbox",
			tabline = {
				lualine_a = { { "tabs", mode = 2 } },
				lualine_z = { "lsp_status" },
			},
			sections = {
				lualine_c = {
					{ "filename", path = 1 },
				},
			},
			extensions = {
				"quickfix",
				"fugitive",
				"mason",
				"oil",
				"trouble",
				"man",
				"lazy",
			},
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
}
