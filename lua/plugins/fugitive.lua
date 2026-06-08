local function setup_keymap() end

return {
	{
		"tpope/vim-fugitive",
		tag = "v3.7",
		config = function()
			setup_keymap()
		end,
	},
}
