return {
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function(_, opts)
			require("cyberdream").setup(opts)
			vim.cmd("colorscheme cyberdream")
		end,
	},
}
