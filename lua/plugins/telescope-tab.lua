return {
	{
		"LukasPietzschmann/telescope-tabs",
		config = function()
			require("telescope").load_extension("telescope-tabs")
			local tabs = require("telescope-tabs")
			vim.keymap.set(
				"n",
				"<leader>ft",
				tabs.list_tabs,
				{ noremap = true, desc = "Browse tabs" }
			)
		end,
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
}
