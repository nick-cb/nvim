local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")
if not ok then
  return
end

lazy.setup({
  {
    "nick-cb/darkplus.nvim",
    config = function()
      vim.cmd([[colorscheme darkplus]])
    end,
    commit = "1826879d9cb14e5d93cd142d19f02b23840408a6"
  },
  -- {
  --   'projekt0n/github-nvim-theme', tag = 'v0.0.7',
  --   config = function()
  --     require('github-theme').setup({})

  --     vim.cmd('colorscheme github_dark')
  --   end,
  -- },
  {
    "kyazdani42/nvim-tree.lua",
    config = function()
      require("user.nvim-tree").setup()
    end,
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
    event = "User DirOpened",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("user.treesitter").setup()
    end,
    cmd = {
      "TSInstall",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
      "TSInstallInfo",
      "TSInstallSync",
      "TSInstallFromGrammar",
    },
    event = "User FileOpened",
  },
  "nvim-treesitter/nvim-treesitter-textobjects",
  {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    config = function()
      require("user.cmp").setup()
    end,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("user.lsp").setup()
    end,
    -- lazy = true,
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { "j-hui/fidget.nvim",       opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("user.null-ls").setup()
    end,
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim", "telescope-fzf-native.nvim" },
  },
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("user.telescope").setup()
    end,
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = "make",
    lazy = true,
    cond = function()
      return vim.fn.executable("make") == 1
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    branch = "main",
    commit = "b02a167",
    config = function()
      require("user.toggleterm").setup()
    end,
    cmd = {
      "ToggleTerm",
      "TermExec",
      "ToggleTermToggleAll",
      "ToggleTermSendCurrentLine",
      "ToggleTermSendVisualLines",
      "ToggleTermSendVisualSelection",
    },
    keys = [[<c-t>]],
  },
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("user.web-devicons").setup()
    end,
    enabled = true,
    lazy = true,
  },
  -- Status Line and Bufferline
  {
    -- "hoob3rt/lualine.nvim",
    "nvim-lualine/lualine.nvim",
    -- "Lunarvim/lualine.nvim",
    config = function()
      require('user.lualine').setup()
    end,
    event = "VimEnter",
  },
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("user.bufferline").setup()
    end,
    branch = "main",
    event = "User FileOpened",
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    after = "nvim-treesitter",
    ft = { "html", "javascript", "markdown", "javascriptreact", "typescript", "typescriptreact" },
  },
  {
    "tpope/vim-surround",
    event = "BufRead",
  },
  {
    "norcalli/nvim-colorizer.lua",
    -- event = "BufRead",
    ft = {
      "yaml",
      "css",
      "html",
      "lua",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "json",
      "dosini",
      "sh",
      "config",
      "python",
      "php",
    },
    config = function()
      require("user.colorizer").config()
    end,
  },
  {
    "unblevable/quick-scope",
  },
  { "mg979/vim-visual-multi", branch = "master" },
  {
    "dsznajder/vscode-es7-javascript-react-snippets",
    build = { "yarn install --frozen-lockfile && yarn compile" },
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },
  {
    "gbprod/substitute.nvim",
    config = function()
      require("user.substitue")
    end,
  },
  { "tpope/vim-repeat" },
  {
    "nick-cb/symbols-outline.nvim",
    config = function()
      require("user.symbol-outline").config()
    end,
    cmd = "SymbolOutlineToggle",
  },
  {
    "tiagovla/scope.nvim",
    config = function()
      require("scope").setup()
    end,
  },
  {
    "nick-cb/telescope-tabs",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("user.telescope-tabs").config()
    end,
  },
  { "tpope/vim-fugitive" },
  { "rickhowe/diffchar.vim" },
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({})
    end,
  },
  {
    "jose-elias-alvarez/typescript.nvim",
    config = function()
      require("typescript").setup({})
    end,
    branch = "no-lspconfig",
    ft = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
  },
  {
    "stevearc/dressing.nvim",
    config = function()
      require("user.dress").config()
    end,
    event = "BufWinEnter",
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("user.autopairs").setup()
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()

    end,
    event = "User FileOpened",
  },
  {
    -- Lazy loaded by Comment.nvim pre_hook
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
  },
  -- Comments
  {
    "numToStr/Comment.nvim",
    config = function()
      require('user.comment').setup()
    end,
    keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
    event = "User FileOpened",
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("user.gitsigns").setup()
    end,
    event = "User FileOpened",
    cmd = "Gitsigns",
  },
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "info",
        auto_session_suppress_dirs = { "~/", "~/Projects" },
      })
    end,
    cmd = { "SaveSession", "RestoreSession", "RestoreSessionFromFile" }
  },
  {
    "RRethy/vim-illuminate",
    config = function()
      require("user.illuminate").setup()
      -- vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "illuminatedWord" })
      -- vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "illuminatedWord" })
      -- vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "illuminatedWord" })
    end
  },
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup()
    end
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>"
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = 'node', -- Node.js version must be > 16.x
        server_opts_overrides = {},
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },
  { "wakatime/vim-wakatime" },
  {
    "nvim-neorg/neorg",
    cmd = "Neorg",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},  -- Loads default behaviour
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.dirman"] = {      -- Manages Neorg workspaces
            config = {
              workspaces = {
                notes = "~/workspaces/notes",
                work = "~/workspaces/ceres",
                tailwind = "~/workspaces/dev/tailwind"
              },
            },
          },
        },
      }
    end,
  },
})
