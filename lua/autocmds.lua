vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	pattern = "*",
	callback = function()
		vim.cmd("set nofoldenable")
	end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	callback = function()
		vim.cmd("set formatoptions-=cro")
	end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	pattern = { "*.tsx", "*.ts", "*.js", "*.jsx" },
	callback = function()
		vim.api.nvim_create_user_command(
			"TypescriptAddMissingImports",
			"lua require('typescript').actions.addMissingImports()",
			{}
		)
		vim.api.nvim_create_user_command(
			"TypescriptOrganizeImports",
			"lua require('typescript').actions.organizeImports()",
			{}
		)
		vim.api.nvim_create_user_command(
			"TypescriptRemoveUnused",
			"lua require('typescript').actions.removeUnused()",
			{}
		)
		vim.api.nvim_create_user_command("TypescriptFixAll", "lua require('typescript').actions.fixAll()", {})
	end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
	pattern = "*",
	callback = function()
		local saved_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd=")
		vim.cmd("tabnext " .. saved_tab)

		local dapui = require("dapui")
		local buf_id = dapui.elements.repl.buffer()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			-- Check if the buffer in the window matches the target buffer
			if vim.api.nvim_win_get_buf(win) == buf_id then
				dapui.open({ reset = true })
				break
			end
		end
	end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	pattern = "*",
	callback = function()
		vim.cmd("hi link illuminatedWord CursorLine")
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
	pattern = "*",
	callback = function(args)
		local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
		if not (vim.fn.expand("%") == "" or buftype == "nofile") then
			vim.cmd("do User FileOpened")
		end
	end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	pattern = "*",
	desc = "Highlight text on yank",
	callback = function()
		vim.highlight.on_yank({ higroup = "Search", timeout = 100 })
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = {
		"qf",
		"help",
		"man",
		"floaterm",
		"lspinfo",
		"lir",
		"lsp-installer",
		"null-ls-info",
		"tsplayground",
		"DressingSelect",
		"Jaq",
		"dap-float",
	},
	callback = function()
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
		vim.opt_local.buflisted = false
	end,
})

local is_directory = function(path)
	local stat = vim.loop.fs_stat(path)
	return stat and stat.type == "directory" or false
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	once = true,
	callback = function(args)
		local bufname = vim.api.nvim_buf_get_name(args.buf)
		if is_directory(bufname) then
			vim.api.nvim_del_augroup_by_name("_dir_opened")
			vim.cmd("do User DirOpened")
			vim.api.nvim_exec_autocmds("BufEnter", {})
		end
	end,
})

-- Add filetype detection based on file extension
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.http",
	command = "set filetype=http",
})

vim.api.nvim_create_autocmd({ "TermLeave" }, {
	pattern = "*",
	callback = function()
		vim.print("BufLeave")
		local dapui = require("dapui")
		local buf_id = dapui.elements.repl.buffer()
		vim.print("close", { buf_id = buf_id })
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			-- Check if the buffer in the window matches the target buffer
			if vim.api.nvim_win_get_buf(win) == buf_id then
				vim.print("dapui.open")
				dapui.open({ reset = true })
				break
			end
		end
	end,
})
