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
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
	},
	{
		"rebelot/kanagawa.nvim",
		config = function()
			require("kanagawa").setup({
				undercurl = true,
			})
		end,
	},
  {
    "nick-cb/melange-nvim"
  },
	-- {
	--   "kyazdani42/nvim-tree.lua",
	--   config = function()
	--     require("user.nvim-tree").setup()
	--   end,
	--   cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
	--   event = "User DirOpened",
	--   commit = "78a9ca5ed6557f29cd0ce203df44213e54bfabb9",
	-- },
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
		commit = "538e37ba87284942c1d76ed38dd497e54e65b891",
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("user.lsp").setup()
		end,
		-- lazy = true,
		dependencies = {
			{
				"williamboman/mason.nvim",
				config = true,
				commit = "cd7835b15f5a4204fc37e0aa739347472121a54c",
			},
			"williamboman/mason-lspconfig.nvim",
			{ "j-hui/fidget.nvim", opts = {}, branch = "legacy" },
			"folke/neodev.nvim",
		},
		-- commit = "d0467b9574b48429debf83f8248d8cee79562586",
	},
	{
		"nvim-telescope/telescope.nvim",
		config = function()
			require("user.telescope").setup()
		end,
		lazy = true,
		dependencies = { "nvim-lua/plenary.nvim" },
		commit = "87e92ea31b2b61d45ad044cf7b2d9b66dad2a618",
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
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("user.lualine").setup()
		end,
		event = "VimEnter",
	},
	-- {
	--   "akinsho/bufferline.nvim",
	--   config = function()
	--     require("user.bufferline").setup()
	--   end,
	--   branch = "main",
	--   event = "User FileOpened",
	--   commit = "6ecd37e0fa8b156099daedd2191130e083fb1490",
	-- },
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
	-- {
	--   "nick-cb/telescope-tabs",
	--   dependencies = { "nvim-telescope/telescope.nvim" },
	--   config = function()
	--     require("user.telescope-tabs").config()
	--   end,
	-- },
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
			require("user.indentlines").setup()
		end,
		event = "User FileOpened",
		main = "ibl",
		opts = {},
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("user.comment").setup()
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
		cmd = { "SessionSave", "SessionRestore", "SessionRestoreFromFile" },
		lazy = true,
	},
	{
		"RRethy/vim-illuminate",
		config = function()
			require("user.illuminate").setup()
			-- vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "illuminatedWord" })
			-- vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "illuminatedWord" })
			-- vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "illuminatedWord" })
		end,
	},
	{
		"folke/trouble.nvim",
		config = function()
			require("user.trouble").setup()
		end,
		commit = "f1168feada93c0154ede4d1fe9183bf69bac54ea",
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("user.copilot").setup()
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"nvim-neorg/neorg",
		cmd = "Neorg",
		build = ":Neorg sync-parsers",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = true,
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {}, -- Loads default behaviour
					["core.concealer"] = {}, -- Adds pretty icons to your documents
					["core.dirman"] = { -- Manages Neorg workspaces
						config = {
							workspaces = {
								notes = "~/workspaces/notes",
								work = "~/workspaces/ceres",
								tailwind = "~/workspaces/dev/tailwind",
							},
						},
					},
				},
			})
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
		lazy = true,
		opts = {
			lang = "javascript",
			console = {
				open_on_runcode = true,
			},
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		lazy = true,
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		config = function()
			require("rainbow-delimiters.setup").setup({
				strategy = {},
				query = {
					tsx = "rainbow-parens",
				},
				highlight = {
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
					"RainbowDelimiterYellow",
					"RainbowDelimiterRed",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
				},
				blacklist = { "sql", "markdown", "ejs", "html" },
			})
		end,
	},
	-- {
	--   'akinsho/flutter-tools.nvim',
	--   lazy = false,
	--   dependencies = {
	--     'nvim-lua/plenary.nvim',
	--     -- 'stevearc/dressing.nvim', -- optional for vim.ui.select
	--   },
	--   config = function()
	--     require("flutter-tools").setup {} -- use defaults
	--   end,
	-- },
	{
		"SmiteshP/nvim-navic",
		config = function()
			require("user.breadcrumbs").setup()
		end,
	},
	{
		"stevearc/oil.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("user.oil").setup()
		end,
	},
	{
		"LunarVim/bigfile.nvim",
		config = function()
			require("bigfile").setup({
				filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
				pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
				features = { -- features to disable
					"indent_blankline",
					"illuminate",
					"lsp",
					-- "treesitter",
					-- "syntax",
					"matchparen",
					"vimopts",
					"filetype",
				},
			})
		end,
	},
	{
		"sustech-data/wildfire.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("wildfire").setup()
		end,
	},
	{
		"chrisgrieser/nvim-spider",
		keys = {
			-- {
			-- 	"e",
			-- 	"<cmd>lua require('spider').motion('e')<CR>",
			-- 	mode = { "n", "o", "x" },
			-- },
			{
				"w",
				"<cmd>lua require('spider').motion('w')<CR>",
				mode = { "n", "o", "x" },
			},
			-- {
			-- 	"b",
			-- 	"<cmd>lua require('spider').motion('b')<CR>",
			-- 	mode = { "n", "o", "x" },
			-- },
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					python = { "isort", "black" },
					-- Use a sub-list to run only the first available formatter
					javascript = { { "prettierd", "prettier" } },
				},
			})
		end,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup({
				default = {},
			})
		end,
	},
	{
		"prochri/telescope-all-recent.nvim",
		config = function()
			require("telescope-all-recent").setup({
				-- your config goes here
			})
		end,
		dependencies = { "kkharji/sqlite.lua" },
	},
	{
		"nick-cb/arrow.nvim",
		opts = {
			show_icons = true,
			leader_key = "<SPACE>;", -- Recommended to be a single key
			buffer_key_maps = { "a", "s", "d", "f", "g" },
			mappings = {
				edit = "E",
				delete_mode = "D",
				clear_all_items = "C",
				toggle = "n",
				open_vertical = "V",
				open_horizontal = "X",
				quit = "q",
			},
		},
	},
})
