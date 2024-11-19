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
		"nick-cb/melange-nvim",
	},
	{
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("user.nvim-tree").setup()
		end,
		cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
		event = "User DirOpened",
		-- commit = "78a9ca5ed6557f29cd0ce203df44213e54bfabb9",
	},
	-- {
	--   "nvim-neo-tree/neo-tree.nvim",
	--   branch = "v3.x",
	--   dependencies = {
	--     "nvim-lua/plenary.nvim",
	--     "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
	--     "MunifTanjim/nui.nvim",
	--     -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	--   },
	--   config = function ()
	--     require("user.neo-tree").setup()
	--   end
	-- },
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
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
		commit = "538e37ba87284942c1d76ed38dd497e54e65b891",
		enabled = true,
	},
	{
		"saghen/blink.cmp",
		config = function()
			require("user.blink").setup()
		end,
		lazy = false, -- lazy loading handled internally
		enabled = false,
		dependencies = "rafamadriz/friendly-snippets",
		version = "v0.*",
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			require("user.lsp").setup()
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		config = function()
			require("user.telescope").setup()
		end,
		lazy = true,
		dependencies = { "nvim-lua/plenary.nvim" },
		tag = "0.1.6",
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
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
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("user.lualine").setup()
		end,
		event = "VimEnter",
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		after = "nvim-treesitter",
		ft = { "html", "javascript", "markdown", "javascriptreact", "typescript", "typescriptreact", "svelte" },
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
			"svelte",
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
		-- commit = "f1168feada93c0154ede4d1fe9183bf69bac54ea",
	},
	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	cmd = "Copilot",
	-- 	event = "InsertEnter",
	-- 	config = function()
	-- 		require("user.copilot").setup()
	-- 	end,
	-- 	enabled = true,
	-- },
	-- {
	-- 	"zbirenbaum/copilot-cmp",
	-- 	config = function()
	-- 		require("copilot_cmp").setup()
	-- 	end,
	-- 	enabled = false,
	-- },
	-- {
	-- 	"nvim-neorg/neorg",
	-- 	cmd = "Neorg",
	-- 	build = ":Neorg sync-parsers",
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- 	lazy = true,
	-- 	config = function()
	-- 		require("neorg").setup({
	-- 			load = {
	-- 				["core.defaults"] = {}, -- Loads default behaviour
	-- 				["core.concealer"] = {}, -- Adds pretty icons to your documents
	-- 				["core.dirman"] = { -- Manages Neorg workspaces
	-- 					config = {
	-- 						workspaces = {
	-- 							notes = "~/workspaces/notes",
	-- 							work = "~/workspaces/works",
	-- 							tailwind = "~/workspaces/dev/tailwind",
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
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
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
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
	-- 	"stevearc/oil.nvim",
	-- 	opts = {},
	-- 	-- Optional dependencies
	-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- 	config = function()
	-- 		require("user.oil").setup()
	-- 	end,
	-- },
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
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					javascript = { { "prettier" } },
					javascriptreact = { { "prettier" } },
					typescript = { { "prettier" } },
					typescriptreact = { { "prettier" } },
					go = { "gofmt" },
					html = { { "prettierd", "prettier" } },
					css = { { "prettierd", "prettier" } },
					svelte = { { "prettier", "prettierd" } },
				},
			})
		end,
	},
	-- {
	-- 	"prochri/telescope-all-recent.nvim",
	-- 	config = function()
	-- 		require("telescope-all-recent").setup({
	-- 			-- your config goes here
	-- 		})
	-- 	end,
	-- 	dependencies = { "kkharji/sqlite.lua" },
	-- },
	-- { "wakatime/vim-wakatime", lazy = false },
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"cbochs/grapple.nvim",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", lazy = true },
		},
		opts = {
			scope = "git_branch",
			icons = true,
			quick_select = "12345",
		},
		keys = {
			{ "<space>;", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },
			{ "<c-s>", "<cmd>Grapple toggle<cr>", desc = "Toggle tag" },
			{ "H", "<cmd>Grapple cycle forward<cr>", desc = "Go to next tag" },
			{ "L", "<cmd>Grapple cycle backward<cr>", desc = "Go to previous tag" },
		},
	},
	{
		"luckasRanarison/tailwind-tools.nvim",
		opts = {
			document_color = {
				kind = "background",
			},
			conceal = {
				symbol = "󱏿", -- only a single character is allowed
				highlight = { -- extmark highlight options, see :h 'highlight'
					fg = "#38BDF8",
				},
			},
		},
	},
	-- {
	-- 	"lukas-reineke/headlines.nvim",
	-- 	after = { "nvim-treesitter" },
	-- 	ft = { "markdown" },
	-- 	config = function()
	-- 		require("headlines").setup()
	-- 	end,
	-- },
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 20, -- Maximum number of lines to show for a single context
				trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
				-- Separator between context and content. Should be a single character string, like '-'.
				-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
				separator = nil,
				zindex = 20, -- The Z-index of the context window
				on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
			})
		end,
	},
	{
		"nick-cb/rgflow.nvim",
		config = function()
			require("rgflow").setup({
				-- Set the default rip grep flags and options for when running a search via
				-- RgFlow. Once changed via the UI, the previous search flags are used for
				-- each subsequent search (until Neovim restarts).
				cmd_flags = "--smart-case --fixed-strings --ignore --max-columns 200",

				-- Mappings to trigger RgFlow functions
				default_trigger_mappings = true,
				-- These mappings are only active when the RgFlow UI (panel) is open
				default_ui_mappings = true,
				-- QuickFix window only mapping
				default_quickfix_mappings = true,
				quickfix = {
					n = {
						["j"] = function()
							print("J hello")
						end,
					},
				},
			})
		end,
	},
	-- {
	-- 	dir = "~/workspaces/personal/nvim-sardaukar",
	-- 	name = "nvim-sardaukar",
	-- 	config = function()
	-- 		require("nvim-sardaukar").setup({})
	-- 		vim.keymap.set("n", "ss", function()
	-- 			require("lazy.core.loader").load("nvim-sardaukar", { reload = "" })
	-- 		end, { noremap = true, silent = true })
	-- 	end,
	-- },
	-- {
	-- 	"echasnovski/mini.files",
	-- 	config = function()
	-- 		require("mini.files").setup({
	--        options = {
	--          permanent_delete = false,
	--        },
	--        windows = {
	--          preview = true,
	--          width_preview = 50
	--        }
	--      })
	-- 	end,
	-- },
	{
		"vhyrro/luarocks.nvim",
		config = function()
			require("luarocks-nvim").setup()
		end,
		opts = {
			rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
		},
	},
	{
		"rest-nvim/rest.nvim",
		ft = "http",
		dependencies = { "luarocks.nvim" },
		config = function()
			require("rest-nvim").setup({})
		end,
	},
	{
		"MeanderingProgrammer/markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		config = function()
			require("render-markdown").setup({})
		end,
	},
	{ "rktjmp/lush.nvim" },
	{
		"microsoft/vscode-js-debug",
		build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
	},
	{
		"mxsdev/nvim-dap-vscode-js",
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
			"leoluz/nvim-dap-go",
			"mfussenegger/nvim-dap-python",
		},
		config = function()
			require("user.dap").setup()
		end,
	},
	{ "preservim/vim-pencil" },
	-- {
	-- 	"xiyaowong/transparent.nvim",
	-- },
	-- { "nvchad/minty", lazy = true },
	-- { "nvchad/volt", lazy = true },
})
