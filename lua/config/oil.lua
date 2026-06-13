local M = {}

function M.open_workspace()
	local config = require("config.telescope")
	config.pick_root("Open oil from root", require("oil").open_float)
end

return M
