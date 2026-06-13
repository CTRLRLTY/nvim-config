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
}
