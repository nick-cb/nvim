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
      -- vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
    end,
    -- commit = "1826879d9cb14e5d93cd142d19f02b23840408a6"
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
    commit = "78a9ca5ed6557f29cd0ce203df44213e54bfabb9",
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
    commit = "51260c02a8ffded8e16162dcf41a23ec90cfba62"
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("user.lsp").setup()
    end,
    -- lazy = true,
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      {
        "williamboman/mason.nvim",
        config = true,
        commit = "cd7835b15f5a4204fc37e0aa739347472121a54c"
      },
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { "j-hui/fidget.nvim", opts = {}, branch = "legacy" },

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
    },
    commit = "d0467b9574b48429debf83f8248d8cee79562586",
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
    commit = "7011eaae0ac1afe036e30c95cf80200b8dc3f21a",
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
    commit = "6c921ca12321edaa773e324ef64ea301a1d0da62",
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
    commit = "6ecd37e0fa8b156099daedd2191130e083fb1490",
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
    build = { "pnpm install && pnpm compile" },
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
    commit = "1f2d1206a03bd3add8aedf6251e4534611de577f",
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("user.autopairs").setup()
    end,
    commit = "0f04d78619cce9a5af4f355968040f7d675854a1",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup({
        indent = {
          char = '▏'
        }
      })
    end,
    event = "User FileOpened",
    main = "ibl",
    opts = {}
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
    commit = "e51f2b142d88bb666dcaa77d93a07f4b419aca70",
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
        -- log_level = "info",
        -- auto_session_suppress_dirs = { "~/", "~/Projects" },
      })
    end,
    commit = "3eb26b949e1b90798e84926848551046e2eb0721",
    cmd = { "SessionSave", "SessionRestore", "SessionRestoreFromFile" }
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
      require("trouble").setup({
        position = "bottom", -- position of the list can be: bottom, top, left, right
        height = 10, -- height of the trouble list when position is top or bottom
        width = 50, -- width of the list when position is left or right
        icons = true, -- use devicons for filenames
        mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
        severity = nil, -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
        fold_open = "", -- icon used for open folds
        fold_closed = "", -- icon used for closed folds
        group = true, -- group results by file
        padding = true, -- add an extra new line on top of the list
        cycle_results = true, -- cycle item list when reaching beginning or end of list
        action_keys = { -- key mappings for actions in the trouble list
          -- map to {} to remove a mapping, for example:
          -- close = {},
          close = "q",                                 -- close the list
          cancel = "<esc>",                            -- cancel the preview and get back to your last window / buffer / cursor
          refresh = "r",                               -- manually refresh
          jump = { "<cr>", "<tab>", "<2-leftmouse>" }, -- jump to the diagnostic or open / close folds
          open_split = { "<c-x>" },                    -- open buffer in new split
          open_vsplit = { "<c-v>" },                   -- open buffer in new vsplit
          open_tab = { "<c-t>" },                      -- open buffer in new tab
          jump_close = { "o" },                        -- jump to the diagnostic and close the list
          toggle_mode = "m",                           -- toggle between "workspace" and "document" diagnostics mode
          switch_severity = "s",                       -- switch "diagnostics" severity filter level to HINT / INFO / WARN / ERROR
          toggle_preview = "P",                        -- toggle auto_preview
          hover = "K",                                 -- opens a small popup with the full multiline message
          preview = "p",                               -- preview the diagnostic location
          open_code_href = "c",                        -- if present, open a URI with more information about the diagnostic error
          -- close_folds = { "zM", "zm" },                -- close all folds
          -- open_folds = { "zR", "zr" },                 -- open all folds
          -- toggle_fold = { "zA", "za" },     -- toggle fold of current file
          previous = "k",                   -- previous item
          next = "j",                       -- next item
          help = "?"                        -- help menu
        },
        multiline = true,                   -- render multi-line messages
        indent_lines = true,                -- add an indent guide below the fold icons
        win_config = { border = "single" }, -- window configuration for floating windows. See |nvim_open_win()|.
        auto_open = false,                  -- automatically open the list when you have diagnostics
        auto_close = false,                 -- automatically close the list when you have no diagnostics
        auto_preview = true,                -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
        auto_fold = false,                  -- automatically fold a file trouble list at creation
        auto_jump = { "lsp_definitions" },  -- for the given modes, automatically jump if there is only a single result
        include_declaration = {},           -- for the given modes, include the declaration of the current symbol in the results
        signs = {
          -- icons / text used for a diagnostic
          error = "",
          warning = "",
          hint = "",
          information = "",
          other = "",
        },
        use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
      })
    end,
    commit = "f1168feada93c0154ede4d1fe9183bf69bac54ea",
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
  -- { "wakatime/vim-wakatime" },
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
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      lang = "javascript",
      console = {
        open_on_runcode = true,
      }
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  -- {
  --   "rktjmp/lush.nvim",
  -- }
  {
    'HiPhish/rainbow-delimiters.nvim',
    config = function()
      require('rainbow-delimiters.setup').setup {
        strategy = {
          -- ...
        },
        query = {
          tsx = 'rainbow-parens'
        },
        highlight = {
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
          'RainbowDelimiterYellow',
          'RainbowDelimiterRed',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
        },
        blacklist = { 'sql', 'markdown' }
      }
    end
  },
  -- {
  --   'akinsho/flutter-tools.nvim',
  --   lazy = false,
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'stevearc/dressing.nvim', -- optional for vim.ui.select
  --   },
  --   config = function()
  --     require("flutter-tools").setup {} -- use defaults
  --   end,
  -- },
  {
    "SmiteshP/nvim-navic",
    config = function()
      require('user.breadcrumbs').setup()
    end
  }
})
