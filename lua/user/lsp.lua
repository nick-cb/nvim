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

local on_attach = function(client, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	local function preview_location_callback(_, result)
		if result == nil or vim.tbl_isempty(result) then
			return nil
		end
		vim.lsp.util.preview_location(result[1], float_config)
	end

	nmap("gd", "<cmd>Trouble lsp_definitions<cr>", "[G]oto [D]efinition")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("gp", function()
		local params = vim.lsp.util.make_position_params()
		return vim.lsp.buf_request(0, "textDocument/definition", params, preview_location_callback)
	end, "[P]eek [D]efinition")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	-- nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")
	nmap("gl", function()
		float_config.scope = "line"
		vim.diagnostic.open_float(0, float_config)
	end, "Show line diagnostics")
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

	-- if client.server_capabilities.inlayHintProvider then
	-- 	vim.lsp.inlay_hint.enable(bufnr, true)
	-- end

	if client.name == "tsserver" then
		client.server_capabilities.document_formatting = false
		client.server_capabilities.document_range_formatting = false
		-- require("nvim-navic").attach(client, bufnr)
	end
end

local servers = {
	-- clangd = {},
	-- gopls = {},
	-- pyright = {},
	rust_analyzer = {},
	tailwindcss = {},
	tsserver = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

M.setup = function()
	require("neodev").setup()

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

	require("mason").setup()
	local mason_lspconfig = require("mason-lspconfig")
	mason_lspconfig.setup({
		ensure_installed = vim.tbl_keys(servers),
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(function(error, result, ctx, config)
		vim.lsp.handlers.hover(error, result, ctx, config)
	end, float_config)
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float_config)
  -- vim.lsp.handlers["textDocument/inlayHint"] = vim.lsp.with(function (error, result, ctx, config)
  --   vim.print({result = result})
  --   local hint = vim.lsp.inlay_hint.get({ bufnr = 0 })
  --   vim.print({hint = {}})
  --   return hint
  -- end, {})
	-- vim.lsp.handlers["textDocument/definition"] = vim.lsp.with(function (error, result, ctx, config)
	--   vim.print(result)
	--   vim.lsp.handlers.definition(error, result, ctx, config)
	-- end, float_config)

	mason_lspconfig.setup_handlers({
		function(server_name)
			require("user.lspconfig").setup_server(server_name, capabilities, on_attach)
		end,
	})
end

return M
