return {
	{
		"rcarriga/nvim-notify",
		tag = "v3.15.0",
		config = function()
			local notify = require("notify")
			vim.notify = notify
		end,
	},
}
