local M = {}

local float_config = {
	focusable = true,
	style = "minimal",
	border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
	source = "always",
	header = "",
	prefix = "",
	format = function(d)
		local code = d.code or (d.user_data and d.user_data.lsp.code)
		if code then
			return string.format("%s [%s]", d.message, code):gsub("1. ", "")
		end
		return d.message
	end,
}

local lsp_keymap = function(event)
	local client = vim.lsp.get_client_by_id(event.data.client_id)
	local bufnr = event.buf
	if not client then
		return
	end
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("gd", "<cmd>Trouble lsp_definitions focus=true<cr>", "[G]oto [D]efinition")
	nmap("gr", "<cmd>Trouble lsp_references focus=true<cr>", "[g]oto [r]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("gp", function()
		local params = vim.lsp.util.make_position_params()
		return vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result)
			if result == nil or vim.tbl_isempty(result) then
				return nil
			end
			vim.lsp.util.preview_location(result[1], float_config)
		end)
	end, "[P]eek [D]efinition")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	-- nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	-- -- nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	-- nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	nmap("K", vim.lsp.buf.hover, "Hover Documentation")

	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		-- print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")
	nmap("gl", function()
		float_config.scope = "line"
		vim.diagnostic.open_float(0, float_config)
	end, "Show line diagnostics")
end

local misc_on_attach = function(event)
	local bufnr = event.buf

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })

	vim.diagnostic.config({
		virtual_text = false,
		signs = {
			active = true,
			values = {
				{ name = "DiagnosticSignError", text = "" },
				{ name = "DiagnosticSignWarn", text = "" },
				{ name = "DiagnosticSignHint", text = "" },
				{ name = "DiagnosticSignInfo", text = "" },
			},
		},
		underline = true,
		update_in_insert = false,
		float = float_config,
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(function(error, result, ctx, config)
		vim.lsp.handlers.hover(error, result, ctx, config)
	end, float_config)
end

local on_attach = function(event)
	lsp_keymap(event)
	misc_on_attach(event)
end

local servers = {
	ts_ls = {},
	rust_analyzer = {},
	tailwindcss = {
		root_dir = vim.fs.find(
			{ "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts" },
			{ upward = true }
		)[1],
		settings = {
			tailwindCSS = {
				experimental = {
					classRegex = {
						{ "[a-zA-Z]*ClassName='([^']+)'" },
						{ '[a-zA-Z]*ClassName="([^"]+)"' },
						{ "[a-zA-Z]*ClassName=`([^`]+)`" },
						{ "[a-zA-Z]*ClassName={*([^]+)}", "'([^']*)'" },
						{ "[a-zA-Z]*ClassName={*([^]+)}", "`([^`]*)`" },
						{ "[a-zA-Z]*ClassName={*([^]+)}", '"([^"]*)"' },
					},
				},
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
			},
		},
	},
	clangd = {},
	eslint = {
		filetypes = { "javascript", "javascriptreact", "typescriptreact", "typescript" },
	},
	basedpyright = {},
	black = {},
	gopls = {},
	zls = {},
}

M.setup = function()
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("nick-personal-lsp-attach", { clear = true }),
		callback = on_attach,
	})

	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		"stylua",
	})

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
	if ok then
		capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
	end

	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
	require("mason-lspconfig").setup({
		handlers = {
			function(server_name)
				local server_config = servers[server_name] or {}
				server_config.capabilities = capabilities
				vim.lsp.config(server_name, server_config)
				vim.lsp.enable(server_name)
			end,
		},
	})
end

return M
