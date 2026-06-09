return {
	{
		"rcarriga/nvim-notify",
		tag = "v3.15.0",
		config = function(_, opts)
			local notify = require("notify")
			notify.setup(
				vim.tbl_extend(
					"force",
					opts,
					{ background_colour = "#000000" }
				)
			)
			vim.notify = notify
		end,
	},
}
