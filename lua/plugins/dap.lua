local function attach_dap_keymap()
	local dap = require("dap")
	-- local buf = vim.api.nvim_get_current_buf()

	if vim.b.dap_keymap_set then
		return
	end

	vim.b.dap_keymap_set = true

	vim.print("Setting DAP Maps")
	vim.keymap.set("n", "<leader>dc", dap.continue, {
		noremap = true,
		desc = "DAP Continue",
	})
	vim.keymap.set("n", "<leader>ds", dap.step_over, {
		noremap = true,
		desc = "DAP Step over",
	})
	vim.keymap.set("n", "<leader>dz", dap.disconnect, {
		noremap = true,
		desc = "DAP Disconnect",
	})
	vim.keymap.set("n", "<leader>di", dap.step_into, {
		noremap = true,
		desc = "DAP Step into",
	})
	vim.keymap.set("n", "<leader>df", dap.step_out, {
		noremap = true,
		desc = "DAP Step Out",
	})
	vim.keymap.set(
		"n",
		"<leader>db",
		dap.toggle_breakpoint,
		{ noremap = true, desc = "DAP Toggle breakpoint" }
	)
	vim.keymap.set(
		"n",
		"<leader>dB",
		dap.set_breakpoint,
		{ noremap = true, desc = "DAP Set breakpoint" }
	)
	vim.keymap.set(
		"n",
		"<leader>dro",
		dap.repl.open,
		{ noremap = true, desc = "DAP Open REPL" }
	)
	vim.keymap.set("n", "<Leader>dbc", function()
		cond = vim.fn.input("breakpoint condition: ")
		dap.set_breakpoint(cond)
	end, { noremap = true, desc = "DAP Set breakpoint condition" })
	vim.keymap.set(
		"n",
		"<leader>drl",
		dap.run_last,
		{ noremap = true, desc = "DAP Run last configuration" }
	)
end

return {
	{
		"mfussenegger/nvim-dap",
		tag = "0.10.0",
		config = function()
			local dap = require("dap")

			dap.configurations = {}
			dap.configurations.lua = {
				{
					type = "nlua",
					request = "attach",
					name = "Attach to running Neovim instance",
				},
			}

			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "current file",
					program = "${file}",
				},
				{
					type = "python",
					request = "launch",
					name = "example jary",
					program = "${file}",
					args = { "./example.jary" },
				},
			}

			dap.configurations.cmake = {
				{
					name = "Build",
					type = "cmake",
					request = "launch",
				},
			}

			dap.adapters.nlua = function(callback, config)
				callback({
					type = "server",
					host = config.host or "127.0.0.1",
					port = config.port or 8086,
				})
			end

			dap.adapters.python = {
				type = "executable",
				command = os.getenv("HOME")
					.. "/pyenv/bin/python",
				args = { "-m", "debugpy.adapter" },
			}

			dap.adapters.cmake = {
				type = "pipe",
				pipe = "${pipe}",
				executable = {
					command = "cmake",
					args = {
						"--debugger",
						"--debugger-pipe",
						"${pipe}",
						"./build",
					},
				},
			}

			dap.listeners.after["launch"]["__personal__"] = function(
				s, --[[@as dap.Session]]
				b --[[@as table]]
			)
				attach_dap_keymap()
			end

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					local ftype = vim.bo.filetype

					if dap.configurations[ftype] == nil then
						return
					end

					attach_dap_keymap()
				end,
				group = vim.api.nvim_create_augroup(
					"DAP mappings",
					{}
				),
			})
		end,
	},
}
