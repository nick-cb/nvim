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
  -- tsserver = {},
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
}

M.setup_server = function (server_name, capabilities, on_attach)
  local config = servers[server_name] or {}
  config.on_attach = on_attach
  config.capabilities = capabilities

  lspconfig[server_name].setup(config)
end

return M
