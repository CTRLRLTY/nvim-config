local function setup_keymap() end

return {
	{
		"tpope/vim-fugitive",
		tag = "v3.7",
		config = function()
			setup_keymap()

			-- see https://github.com/neovim/neovim/issues/22696#issuecomment-3906586437
			vim.opt.diffopt:remove("linematch:40")
		end,
	},
}
