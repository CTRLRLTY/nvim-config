---@alias RootSelectCallback fun(root: string): nil

---@param title string
---@param on_select RootSelectCallback
local function pick_root(title, on_select)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local raw = vim.fn.uniq(vim.lsp.buf.list_workspace_folders())
	local folders = type(raw) == "table" and raw or {}

	local entries = {
		{
			label = "cd: " .. vim.fn.expand("%:p:h"),
			path = vim.fn.expand("%:p:h"),
		},
	}
	for _, folder in ipairs(folders) do
		table.insert(
			entries,
			{ label = "workspace: " .. folder, path = folder }
		)
	end

	pickers.new({}, {
		prompt_title = title,
		finder = finders.new_table({
			results = entries,
			entry_maker = function(entry)
				return {
					value = entry.path,
					display = entry.label,
					ordinal = entry.label,
				}
			end,
		}),
		sorter = conf.generic_sorter({}),
		attach_mappings = function(bufnr)
			actions.select_default:replace(function()
				actions.close(bufnr)
				local sel = action_state.get_selected_entry()
				if sel then
					vim.defer_fn(function()
						on_select(sel.value)
					end, 10)
				end
			end)
			return true
		end,
	}):find()
end

local function search_live_string()
	pick_root("Grep string from root", function(root)
		require("telescope.builtin").live_grep({ cwd = root })
	end)
end

local function set_keymap()
	local builtin = require("telescope.builtin")

	vim.keymap.set("n", "<leader>fF", function()
		local root = vim.lsp.buf.list_workspace_folders()[1]

		builtin.find_files({
			cwd = root,
			no_ignore = true,
		})
	end, {
		noremap = true,
		desc = "Browse current workspace [include ignored]",
	})

	vim.keymap.set(
		"n",
		"<leader>fim",
		":Telescope find_files search_dirs={vim.fs.dirname(vim.env.MYVIMRC)}<cr>",
		{ noremap = true, desc = "Browse init VIM" }
	)
	vim.keymap.set("n", "<leader>ff", function()
		local root = vim.lsp.buf.list_workspace_folders()[1]

		builtin.find_files({ cwd = root })
	end, {
		noremap = true,
		desc = "Browse current workspace",
	})

	vim.keymap.set("n", "<leader>fgf", builtin.git_files, {
		noremap = true,
		desc = "Browse git commited files",
	})
	vim.keymap.set(
		"n",
		"<leader>flg",
		search_live_string,
		{ noremap = true, desc = "Browse live grep" }
	)
	vim.keymap.set(
		"n",
		"<leader>fm",
		builtin.marks,
		{ noremap = true, desc = "Browse Marks" }
	)
	vim.keymap.set("n", "<leader>fM", function()
		builtin.man_pages({ sections = { "ALL" } })
	end, { noremap = true, desc = "Browse man page" })
	vim.keymap.set(
		"n",
		"<leader>fr",
		builtin.registers,
		{ noremap = true, desc = "Browse registers" }
	)
	vim.keymap.set("n", "<leader>fzf", builtin.current_buffer_fuzzy_find, {
		noremap = true,
		desc = "Fuzzy find current buffer",
	})
	vim.keymap.set(
		"n",
		"<leader>fc",
		builtin.commands,
		{ noremap = true, desc = "Browse commands" }
	)
	vim.keymap.set("n", "<leader>fC", builtin.command_history, {
		noremap = true,
		desc = "Browse command history",
	})
	vim.keymap.set("n", "<leader>fS", builtin.search_history, {
		noremap = true,
		desc = "Browse search history",
	})
	vim.keymap.set(
		"n",
		"<leader>fvo",
		builtin.vim_options,
		{ noremap = true, desc = "Browse vim options" }
	)
	vim.keymap.set(
		"n",
		"<leader>fvk",
		builtin.keymaps,
		{ noremap = true, desc = "Browse keymaps" }
	)
	vim.keymap.set("n", "<leader>fll", builtin.loclist, {
		noremap = true,
		desc = "Browse location list",
	})
	vim.keymap.set(
		"n",
		"<leader>fj",
		builtin.jumplist,
		{ noremap = true, desc = "Browse jump list" }
	)
	vim.keymap.set(
		"n",
		"<leader>fac",
		builtin.autocommands,
		{ noremap = true, desc = "Browse autocommands" }
	)

	vim.keymap.set(
		"n",
		"<leader>fb",
		builtin.buffers,
		{ noremap = true, desc = "Browse buffers" }
	)
	vim.keymap.set(
		"n",
		"<leader>fh",
		builtin.help_tags,
		{ noremap = true, desc = "Browse help tags" }
	)
end

return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim", -- optional but recommended
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function(_, opts)
			require("telescope").setup(opts)
			set_keymap()
		end,
	},
}
