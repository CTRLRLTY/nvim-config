return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		priority = 1000,
		opts = {
			ensure_installed = {
				"go",
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
			},
		},
		lazy = false,
	},
}
