return {
	{
		"nvim-telescope/telescope-dap.nvim",
		config = function()
			require("telescope").load_extension("dap")
			local teledap = require("telescope").extensions.dap
			vim.keymap.set(
				"n",
				"<leader>fdc",
				teledap.configurations,
				{
					noremap = true,
					desc = "Browse DAP configurations",
				}
			)
			vim.keymap.set(
				"n",
				"<leader>fdb",
				teledap.list_breakpoints,
				{
					noremap = true,
					desc = "Browse DAP breakpoints",
				}
			)
			vim.keymap.set("n", "<leader>fdv", teledap.variables, {
				noremap = true,
				desc = "Browse DAP variables",
			})
		end,
		keys = {
			{
				"<leader>fdf",
				"<cmd>Telescope dap frames",
				desc = "Browse DAP stack frames",
			},
		},
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"mfussenegger/nvim-dap",
		},
	},
}
