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

local function open_oil_workspace()
	pick_root("Open oil from root", require("oil").open_float)
end

function dap_go_program()
	local routine = function(dap_run_co)
		require("telescope.builtin").git_files({
			prompt_title = "Select File to Debug",
			file_ignore_patterns = { "([^g][^o])$" },
			attach_mappings = function(_, map)
				local actions = require("telescope.actions")
				local state = require("telescope.actions.state")

				actions.select_default:replace(
					function(prompt_bufnr)
						local entry =
							state.get_selected_entry()
						local file_path = entry.path
							or entry.filename

						vim.print(file_path)
						actions.close(prompt_bufnr)
						coroutine.resume(
							dap_run_co,
							file_path
						)
					end
				)

				return true
			end,
		})
	end

	return coroutine.create(routine)
end

return {
	-- {
	-- 	"romgrk/barbar.nvim",
	-- 	dependencies = {
	-- 		"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
	-- 		"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
	-- 	},
	-- 	init = function()
	-- 		vim.g.barbar_auto_setup = false
	-- 	end,
	-- 	config = function(_, opts)
	-- 		require("barbar").setup(opts)
	--
	-- 		vim.keymap.set("n", "gt", "<Cmd>BufferNext<CR>", {
	-- 			noremap = false,
	-- 			silent = true,
	-- 			desc = "Go to next buffer",
	-- 		})
	--
	-- 		vim.keymap.set("n", "gT", "<Cmd>BufferPrevious<CR>", {
	-- 			noremap = false,
	-- 			silent = true,
	-- 			desc = "Go to previous buffer",
	-- 		})
	--
	-- 		vim.keymap.set(
	-- 			"n",
	-- 			"<leader>wb",
	-- 			"<Cmd>BufferPick<CR>",
	-- 			{ noremap = true, desc = "Tab buffer pick" }
	-- 		)
	--
	-- 		vim.keymap.set(
	-- 			"n",
	-- 			"<leader>wB",
	-- 			"<Cmd>BufferPickDelete<CR>",
	-- 			{
	-- 				noremap = true,
	-- 				desc = "Tab buffer pick delete",
	-- 			}
	-- 		)
	-- 	end,
	-- 	version = "^1.0.0", -- optional: only update when a new 1.x version is released
	-- },

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
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			require("gruvbox").setup()
			vim.go.background = "dark"
			vim.cmd("colorscheme gruvbox")

			vim.api.nvim_create_autocmd("vimenter", {
				pattern = "*",
				command = "colorscheme gruvbox",
				nested = true,
			})
		end,
		lazy = false,
	},
	{
		"leoluz/nvim-dap-go",
		opts = {
			dap_configurations = {
				{
					type = "go",
					name = "Debug Project",
					request = "launch",
					program = dap_go_program,
				},
			},
		},
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		tag = "v4.0.0",
		config = function()
			-- require('dap.ext.vscode').load_launchjs()
			require("dapui").setup()
			dapui = require("dapui")
			vim.keymap.set(
				"n",
				"<Leader>dt",
				dapui.toggle,
				{ desc = "DAP toggle UI" }
			)
		end,
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
	},
	{
		"ahmedkhalf/project.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		opts = {
			sync_root_with_cwd = true,
			respect_buf_cwd = true,
			update_focused_file = {
				enable = true,
				update_root = true,
			},
		},
		config = function(_, opts)
			require("project_nvim").setup(opts)
			require("telescope").load_extension("projects")
			projects = require("telescope").extensions.projects
			vim.keymap.set(
				"n",
				"<Leader>fp",
				projects.projects,
				{ desc = "Browse projects" }
			)
		end,
	},
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			view_options = {
				show_hidden = true,
			},
		},
		-- Optional dependencies
		dependencies = {
			{ "echasnovski/mini.icons", config = true },
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{
				"<leader>od",
				open_oil_workspace,
				desc = "Open parent directory",
			},
		},
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
	},
}
