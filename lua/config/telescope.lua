local M = {}

---@alias RootSelectCallback fun(root: string): nil

---@param title string
---@param on_select RootSelectCallback
function M.pick_root(title, on_select)
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

function M.live_string()
	M.pick_root("Grep string from root", function(root)
		require("telescope.builtin").live_grep({ cwd = root })
	end)
end

return M
