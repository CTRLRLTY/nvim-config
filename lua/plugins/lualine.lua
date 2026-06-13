return {
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			theme = "gruvbox",
			tabline = {
				lualine_a = { { "tabs", mode = 2 } },
			},
			sections = {
				lualine_c = {
					{ "filename", path = 3 },
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
