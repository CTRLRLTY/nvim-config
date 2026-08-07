---@class PythonInterpreterEntry
---@field path string
---@field label string

local M = {}

--- Currently selected Python interpreter path for LSP from Telescope picker
---@type string|nil
M.selected_python_path = nil

--- Currently selected Python interpreter path for DAP from Telescope picker
---@type string|nil
M.selected_dap_python_path = nil

--- Get active Python executable for LSP.
---@return string
function M.get_python_executable()
	if M.selected_python_path and M.selected_python_path ~= "" and vim.fn.executable(M.selected_python_path) == 1 then
		return M.selected_python_path
	end

	local interpreters = M.find_python_interpreters()
	if #interpreters > 0 then
		return interpreters[1].path
	end

	local sys_py = vim.fn.exepath("python3")
	if sys_py and sys_py ~= "" then
		return sys_py
	end

	return "python3"
end

--- Get active Python executable for DAP debugging sessions.
---@return string
function M.get_dap_python_executable()
	if M.selected_dap_python_path and M.selected_dap_python_path ~= "" and vim.fn.executable(M.selected_dap_python_path) == 1 then
		return M.selected_dap_python_path
	end
	return M.get_python_executable()
end

--- Search for Python executables in VIRTUAL_ENV, local .venv, tool directories, and PATH.
---@return PythonInterpreterEntry[]
function M.find_python_interpreters()
	---@type PythonInterpreterEntry[]
	local results = {}
	---@type table<string, boolean>
	local seen = {}

	---@param path string|nil
	---@param label string|nil
	local function add(path, label)
		if path and path ~= "" and vim.fn.executable(path) == 1 and not seen[path] then
			seen[path] = true
			table.insert(results, { path = path, label = label or path })
		end
	end

	-- Active environment
	if vim.env.VIRTUAL_ENV then
		add(
			vim.env.VIRTUAL_ENV .. "/bin/python",
			"Active ($VIRTUAL_ENV): " .. vim.env.VIRTUAL_ENV
		)
	end

	-- Local workspace virtualenv
	local cwd = vim.fn.getcwd()
	add(cwd .. "/.venv/bin/python", "Local Workspace (.venv): " .. cwd .. "/.venv")

	-- Global / tool virtualenvs (uv, poetry, conda, etc.)
	local home = vim.env.HOME or "~"
	local search_globs = {
		home .. "/.virtualenvs/*/bin/python",
		home .. "/.cache/pypoetry/virtualenvs/*/bin/python",
		home .. "/.local/share/uv/tools/*/bin/python",
		home .. "/.local/share/virtualenvs/*/bin/python",
		home .. "/.conda/envs/*/bin/python",
		home .. "/miniconda3/envs/*/bin/python",
		home .. "/anaconda3/envs/*/bin/python",
	}
	for _, pattern in ipairs(search_globs) do
		local matches = vim.fn.glob(pattern, true, true)
		if type(matches) == "table" then
			for _, path in ipairs(matches) do
				add(path, "Discovered Venv: " .. path)
			end
		end
	end

	-- Fallback PATH binaries
	local sys_python3 = vim.fn.exepath("python3")
	if sys_python3 and sys_python3 ~= "" then
		add(sys_python3, "System PATH: " .. sys_python3)
	end

	local sys_python = vim.fn.exepath("python")
	if sys_python and sys_python ~= "" then
		add(sys_python, "System PATH: " .. sys_python)
	end

	return results
end

--- Select a Python interpreter via Telescope.
---@param title string
---@param on_select fun(path: string)
---@return nil
function M.select_python_interpreter(title, on_select)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local interpreters = M.find_python_interpreters()

	if #interpreters == 0 then
		vim.notify("No Python interpreters found.", vim.log.levels.WARN, { title = title })
		return
	end

	pickers.new({}, {
		prompt_title = title,
		finder = finders.new_table({
			results = interpreters,
			---@param entry PythonInterpreterEntry
			entry_maker = function(entry)
				return {
					value = entry.path,
					display = entry.label,
					ordinal = entry.label .. " " .. entry.path,
				}
			end,
		}),
		sorter = conf.generic_sorter({}),
		attach_mappings = function(bufnr)
			actions.select_default:replace(function()
				actions.close(bufnr)
				local sel = action_state.get_selected_entry()
				if sel and type(sel.value) == "string" then
					on_select(sel.value)
				end
			end)
			return true
		end,
	}):find()
end

--- Select a Python interpreter for LSP via Telescope.
---@return nil
function M.select_lsp_python_interpreter()
	M.select_python_interpreter("Select Python Interpreter for LSP", function(path)
		M.set_python_interpreter(path)
	end)
end

--- Select a Python interpreter for DAP via Telescope.
---@return nil
function M.select_dap_python_interpreter()
	M.select_python_interpreter("Select Python Interpreter for DAP", function(path)
		M.selected_dap_python_path = path
		vim.notify(
			"Selected DAP Python Interpreter:\n" .. path,
			vim.log.levels.INFO,
			{ title = "DAP Python Setup" }
		)
	end)
end

--- Get active LSP clients attached to Python buffers.
---@return vim.lsp.Client[]
function M.get_python_lsp_clients()
	---@type vim.lsp.Client[]
	local python_clients = {}
	---@type table<integer, boolean>
	local seen = {}

	for _, client in ipairs(vim.lsp.get_clients()) do
		local is_python = false
		if client.config and client.config.filetypes then
			for _, ft in ipairs(client.config.filetypes) do
				if ft == "python" then
					is_python = true
					break
				end
			end
		end

		if not is_python then
			local attached = client.attached_buffers or {}
			for buf, _ in pairs(attached) do
				if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "python" then
					is_python = true
					break
				end
			end
		end

		if is_python and not seen[client.id] then
			seen[client.id] = true
			table.insert(python_clients, client)
		end
	end

	return python_clients
end

--- Set pythonPath for active Python LSPs and restart them.
---@param python_path string
---@return nil
function M.set_python_interpreter(python_path)
	vim.env.VIRTUAL_ENV = python_path:gsub("/bin/python$", "")

	local clients = M.get_python_lsp_clients()

	if #clients == 0 then
		vim.notify("No active Python LSP client found.", vim.log.levels.WARN, { title = "LSP Python Setup" })
		return
	end

	---@type string[]
	local restarted_names = {}
	for _, client in ipairs(clients) do
		table.insert(restarted_names, client.name)

		local config = vim.deepcopy(client.config)
		config.settings = config.settings or {}
		config.settings.python = config.settings.python or {}
		config.settings.python.pythonPath = python_path

		client.stop()

		vim.defer_fn(function()
			vim.lsp.start(config)
		end, 300)
	end

	vim.notify(
		"Selected Python Interpreter & Restarted ["
			.. table.concat(restarted_names, ", ")
			.. "]:\n"
			.. python_path,
		vim.log.levels.INFO,
		{ title = "LSP Python Setup" }
	)
end

--- Display notification with current Python environment and LSP status.
---@return nil
function M.show_active_python_info()
	---@type string[]
	local lines = {}
	table.insert(lines, "Active VIRTUAL_ENV: " .. (vim.env.VIRTUAL_ENV or "(none)"))

	local host_prog = vim.g.python3_host_prog
	if host_prog and type(host_prog) == "string" then
		table.insert(lines, "python3_host_prog: " .. host_prog)
	else
		local sys_py = vim.fn.exepath("python3")
		table.insert(
			lines,
			"python3_host_prog: (not set - using PATH: "
				.. (sys_py ~= "" and sys_py or "none")
				.. ")"
		)
	end

	table.insert(lines, "DAP Python Adapter: " .. M.get_dap_python_executable())

	local clients = M.get_python_lsp_clients()
	if #clients > 0 then
		for _, client in ipairs(clients) do
			local py_path = vim.tbl_get(client.config, "settings", "python", "pythonPath")
			table.insert(
				lines,
				"LSP Client ["
					.. client.name
					.. "] pythonPath: "
					.. (py_path or "(default)")
			)
		end
	else
		table.insert(lines, "LSP Client: No active Python LSP client")
	end

	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Python Interpreter Info" })
end

return M
