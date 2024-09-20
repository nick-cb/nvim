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

	nmap("gd", "<cmd>Trouble lsp_definitions<cr>", "[G]oto [D]efinition")
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
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	-- nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

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

local deno_on_attach = function(event)
	local client = vim.lsp.get_client_by_id(event.data.client_id)
	if not client then
		return
	end
	if require("lspconfig").util.root_pattern("deno.json", "deno.jsonc")(vim.fn.getcwd()) then
		if client.name == "tsserver" then
			client.stop()
			return
		end
	end
end

local tsserver_on_attach = function(event)
	local client = vim.lsp.get_client_by_id(event.data.client_id)
	if not client then
		return
	end
	-- if client.name == "tsserver" then
	-- 	client.server_capabilities.document_formatting = false
	-- 	client.server_capabilities.document_range_formatting = false
	-- end
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
	deno_on_attach(event)
	tsserver_on_attach(event)
	misc_on_attach(event)
end

local root_pattern = require("lspconfig").util.root_pattern
local servers = {
	tsserver = {},
	rust_analyzer = {},
	tailwindcss = {
		root_dir = root_pattern(
			"tailwind.config.js",
			"tailwind.config.cjs",
			"tailwind.config.mjs",
			"tailwind.config.ts"
		),
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
	-- sourcekit = {
	-- 	settings = {
	-- 		cmd = "sourcekit-lsp",
	-- 		filetypes = { "swift", "objective-c", "objective-cpp" },
	-- 	},
	-- },
	clangd = {},
	-- dartls = {},
	-- hls = {},
	eslint = {
		filetypes = { "javascript", "javascriptreact", "typescriptreact" },
	},
	denols = {
    root_dir = root_pattern("deno.json", "deno.jsonc")
		-- server = {
		--     settings = {
		--         deno = {
		--             enable = true,
		--             suggest = {
		--                 imports = {
		--                     hosts = {
		--                         ["https://crux.land"] = true,
		--                         ["https://deno.land"] = true,
		--                         ["https://x.nest.land"] = true
		--                     }
		--                 }
		--             },
		--         },
		--     }
		-- },
	},
  basedpyright = {},
  black = {}
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
	capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
	require("mason-lspconfig").setup({
		handlers = {
			function(server_name)
				local server = servers[server_name] or {}
				-- This handles overriding only values explicitly passed
				-- by the server configuration above. Useful when disabling
				-- certain features of an LSP (for example, turning off formatting for tsserver)
				-- server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
        -- if server_name == 'lua_ls' then
        --   vim.print(server)
        -- end
				require("lspconfig")[server_name].setup(server)
			end,
		},
	})
end

return M
