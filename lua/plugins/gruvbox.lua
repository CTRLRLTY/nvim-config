return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			require("gruvbox").setup()
			vim.go.background = "dark"
			vim.cmd("colorscheme gruvbox")

			vim.api.nvim_create_autocmd("VimEnter", {
				pattern = "*",
				command = "colorscheme gruvbox",
				nested = true,
			})
		end,
		lazy = false,
	},
}
