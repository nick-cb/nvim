local icons = require("icons")

local float_config = {
	focusable = true,
	style = "minimal",
	source = true,
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

-- replaces the deprecated vim.diagnostic.goto_next/goto_prev (which opened a float)
local function diagnostic_jump(count)
	if vim.diagnostic.jump({ count = count }) then
		vim.diagnostic.open_float(float_config)
	end
end

local servers = {
	-- ts_ls = {},
  tsgo = {
    -- nvim-lspconfig's tsgo config wraps `tsc` and warns "tsgo is deprecated" from on_init;
    -- we still use the mason `tsgo` binary, so silence it
    on_init = function() end,
  },
  ruby_lsp = {},
	rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					enable = false,
				},
			},
		},
	},
	tailwindcss = {
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
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = {
						"vim",
						"describe",
						"it",
						"assert",
						"stub",
						"mock",
						"before_each",
						"after_each",
					},
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = { enable = false },
			},
		},
	},
	clangd = {},
	eslint = {
		filetypes = { "javascript", "javascriptreact", "typescriptreact", "typescript" },
		autostart = false,
	},
	basedpyright = {},
	gopls = {},
	zls = {},
}

-- formatters used by conform.nvim (see formatting.lua)
local formatters = { "stylua", "isort", "black", "biome", "prettier", "prettierd" }

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		opts = {},
		config = function()
			vim.diagnostic.config({
				virtual_text = false,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
						[vim.diagnostic.severity.INFO] = "",
					},
				},
				underline = true,
				update_in_insert = false,
				float = float_config,
			})

			-- completion capabilities are registered by blink.cmp via vim.lsp.config("*")
			local ensure_installed = vim.list_extend(vim.tbl_keys(servers), formatters)
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			for name, config in pairs(servers) do
				vim.lsp.config(name, config)
			end
			-- vim.lsp.enable("tsgo")
			require("mason-lspconfig").setup({
				-- ensure_installed = servers,
				automatic_enable = {
					exclude = { "eslint", "ts_ls" },
				},
			})
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {
			auto_refresh = false,
			modes = {
				lsp_references = {
					filter = {
						function(item)
							return item.client ~= "tsserver"
						end,
					},
				},
				lsp_definitions = {
					filter = {
						function(item)
							return item.client ~= "tsserver"
						end,
					},
				},
			},
		},
		keys = {
			{ "gd", "<cmd>Trouble lsp_definitions focus=true win.position=bottom pinned=true<cr>" },
			-- nowait: don't wait 'timeoutlen' for the built-in grn/gra/grr/gri/grt mappings
			{ "gr", "<cmd>Trouble lsp_references focus=true win.position=bottom pinned=true<cr>", nowait = true },
			{ "gi", "<cmd>Trouble lsp_implementations focus=true win.position=bottom pinned=true<cr>" },
			{
				"gl",
				function()
					vim.diagnostic.open_float(float_config)
				end,
			},
			{ "<leader>lj", function() diagnostic_jump(1) end },
			{ "<leader>lk", function() diagnostic_jump(-1) end },
			{ "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>" },
			{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>" },
		},
	},
}
