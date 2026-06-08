return {
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			theme = "gruvbox",
			tabline = {
				lualine_a = { "tabs" },
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
