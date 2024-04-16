local M = {}

local ok, lspconfig = pcall(require, "lspconfig")

if not ok then
  M.setup_server = function ()
    print("lspconfig not found")
  end
  return M
end

local root_pattern = lspconfig.util.root_pattern;

local servers = {
  tsserver = {
		settings = {
			typescript = {
				inlayHints = {
					enumMemberValues = true,
					parameterNames = { enabled = "literals" },
					includeInlayParameterNameHints = "none", -- 'none' | 'literals' | 'all'
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayVariableTypeHints = true,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHintsWhenTypeMatchesName = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
          suppressWhenArgumentMatchesName = true,
          suppressWhenTypeMatchesName = true
				},
			},
			javascript = {
				inlayHints = {
					enumMemberValues = { enabled = true },
					parameterNames = { enabled = "all" },
					includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
					includeInlayParameterNameHintsWhenArgumentMatchesName = true,
					includeInlayVariableTypeHints = true,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHintsWhenTypeMatchesName = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
          suppressWhenArgumentMatchesName = false,
          suppressWhenTypeMatchesName = false
				},
			},
		}
  },
  rust_analyzer = {},
  tailwindcss = {
    root_dir = root_pattern('tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.mjs', 'tailwind.config.ts'),
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
      }
    }
  },
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    }
  },
  sourcekit = {
    settings = {
      cmd = "sourcekit-lsp",
      filetypes = { "swift", "objective-c", "objective-cpp" },
    },
  },
  clangd = {},
  dartls = {},
  hls = {},
  eslint = {
    filetypes = { "javascript", "javascriptreact" },
  }
}

M.setup_server = function (server_name, capabilities, on_attach)
  local config = servers[server_name] or {}
  config.on_attach = on_attach
  config.capabilities = capabilities

  lspconfig[server_name].setup(config)
end

return M
