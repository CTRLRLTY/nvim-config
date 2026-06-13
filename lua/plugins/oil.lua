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
				"<leader>odw",
				require("config.oil").open_workspace,
				desc = "Open active workspace",
			},
			{
				"<leader>odc",
				require("config.oil").open_cwd,
				desc = "Open current directory",
			},
		},
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
	},
}
