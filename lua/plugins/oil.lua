return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			view_options = {
				show_hidden = true,
			},
		},
		-- Optional dependencies
		dependencies = {
			{ "echasnovski/mini.icons", config = true },
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{
				"<leader>od",
				require("config.oil").open_workspace,
				desc = "Open parent directory",
			},
		},
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
	},
}
