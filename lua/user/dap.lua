local M = {}

local setup_keymap = function(dap, dapui)
	vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
	vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
	vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
	vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
	vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
	--[[
            <f24> = <S-F12>
            When press Shift+12, the keystroke neovim receive is ^[[24;2~, which equivilent to <f24>
            To find the keystroke and which key associate with it:
            - Press Control+v then Shift+12 in the terminal to get the keystroke (^[[24;2~)
            - Using "nvim -V3log" then ":q" to get terminfo
            - Find the key associate with the keystroke
          ]]
	vim.keymap.set("n", "<f24>", function()
		local i = 0
		while dap.session() ~= nil do
			i = i + 1
			if i >= 50 then
				break
			end
			dap.terminate()
			dap.close()
		end
		dapui.close()
	end, { silent = true })
	vim.keymap.set("n", "<F12>", function()
		dapui.toggle()
	end, { desc = "Debug: Toggle debug ui" })

	dap.listeners.after["event_initialized"]["me"] = function()
		for _, buf in pairs(vim.api.nvim_list_bufs()) do
			-- 	local keymaps = vim.api.nvim_buf_get_keymap(buf, "n")
			-- 	for _, keymap in pairs(keymaps) do
			-- 		if keymap.lhs == "K" then
			-- 			vim.api.nvim_buf_del_keymap(buf, "n", "K")
			-- 			vim.api.nvim_set_keymap(
			-- 				"n",
			-- 				"K",
			-- 				'<Cmd>lua require("dap.ui.widgets").hover()<CR>',
			-- 				{ silent = true }
			-- 			)
			-- 		end
			-- 	end
			pcall(vim.keymap.del, "n", "K", { buffer = buf })
			vim.keymap.set("n", "K", '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
		end
	end

	dap.listeners.after["event_terminated"]["me"] = function()
		vim.print("terminated")
		for _, buf in pairs(vim.api.nvim_list_bufs()) do
			pcall(vim.keymap.del, "n", "K")
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buf, desc = "Hover Documentation" })
		end
	end

	dap.listeners.after["event_exited"]["me"] = function()
		vim.print("exit")
		for _, buf in pairs(vim.api.nvim_list_bufs()) do
			pcall(vim.keymap.del, "n", "K")
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buf, desc = "Hover Documentation" })
		end
	end
end

local setup_dap = function(dap, dapui)
	require("mason-nvim-dap").setup({
		automatic_installation = true,
		handlers = {},
		ensure_installed = {
			"delve",
		},
	})

	dapui.setup({
		icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
		controls = {
			icons = {
				pause = "⏸",
				play = "▶",
				step_into = "⏎",
				step_over = "⏭",
				step_out = "⏮",
				step_back = "b",
				run_last = "▶▶",
				terminate = "⏹",
				disconnect = "⏏",
			},
		},
	})

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end

	require("dap-go").setup({
		delve = {
			detached = vim.fn.has("win32") == 0,
		},
	})

	require("dap-vscode-js").setup({
		-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
		debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
		-- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
		adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
		-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
		-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
		-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
	})

	require("dap-python").setup()

	require("dap.ext.vscode").load_launchjs(nil, { javascript = "js" })
	vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
	vim.api.nvim_create_augroup("DAP_UI_RESET", { clear = true })

	local nvimtreeApi = require("nvim-tree.api")
	local Event = nvimtreeApi.events.Event
	nvimtreeApi.events.subscribe(Event.TreeClose, function()
		local buf_id = dapui.elements.repl.buffer()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			-- Check if the buffer in the window matches the target buffer
			if vim.api.nvim_win_get_buf(win) == buf_id then
				dapui.open({ reset = true })
				break
			end
		end
	end)
end

M.setup = function()
	local ok_dap, dap = pcall(require, "dap")
	local ok_dapui, dapui = pcall(require, "dapui")

	if not ok_dap or not ok_dapui then
		vim.print("Something wrong with dap or dapui")
		return
	end

	setup_dap(dap, dapui)
	setup_keymap(dap, dapui)
end

return M
