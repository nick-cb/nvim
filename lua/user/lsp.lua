local M = {}

local float_config = {
  focusable = true,
  style = "minimal",
  border = {"┌", "─", "┐", "│", "┘", "─", "└", "│"},
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

  nmap("gd", "<cmd>Trouble lsp_definitions<cr>", "[G]oto [D]efinition")
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  -- nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

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

  if client.name == "tsserver" then
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
    require("nvim-navic").attach(client, bufnr)
  end
end

local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  rust_analyzer = {},
  tailwindcss = {
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
  -- tsserver = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  -- dartls = {
  --   cmd = { "dart", "language-server", "--protocol=lsp" }
  -- }
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

  mason_lspconfig.setup_handlers({
    function(server_name)
      require("user.lspconfig").setup_server(
        server_name,
        capabilities,
        on_attach
      )
    end,
  })
end

return M
