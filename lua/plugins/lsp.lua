local float_config = {
  focusable = true,
  style = "minimal",
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

local servers = {
  ts_ls = {},
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
  black = {},
  gopls = {},
  zls = {},
}

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
      -- require("user.lsp").setup()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("nick-personal-lsp-attach", { clear = true }),
        callback = function(event)
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
        end,
      })

      local ensure_installed = vim.tbl_keys(servers or {})
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
      end

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
      for name, config in pairs(servers) do
        vim.lsp.config(name, config)
      end
      require("mason-lspconfig").setup({
        -- ensure_installed = servers,
        automatic_enable = {
          exclude = { "eslint" },
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
      { "gr", "<cmd>Trouble lsp_references focus=true win.position=bottom pinned=true<cr>" },
      { "gi", "<cmd>Trouble lsp_implementations focus=true win.position=bottom pinned=true<cr>" },
      { "K", vim.lsp.buf.hover },
      {
        "gl",
        function()
          vim.diagnostic.open_float(0, float_config)
        end,
      },
      { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>" },
      { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>" },
      { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>" },
      { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>" },
    },
  },
}
