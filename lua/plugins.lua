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
		commit = "78a9ca5ed6557f29cd0ce203df44213e54bfabb9",
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
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"hrsh7th/cmp-nvim-lsp",
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
		commit = "f1168feada93c0154ede4d1fe9183bf69bac54ea",
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
			-- Creates a beautiful debugger UI
			"rcarriga/nvim-dap-ui",

			-- Required dependency for nvim-dap-ui
			"nvim-neotest/nvim-nio",

			-- Installs the debug adapters for you
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",

			-- Add your own debuggers here
			"leoluz/nvim-dap-go",
		},
		keys = function(_, keys)
			local dap = require("dap")
			local dapui = require("dapui")
			return {
				-- Basic debugging keymaps, feel free to change to your liking!
				{ "<F5>", dap.continue, desc = "Debug: Start/Continue" },
				{ "<F1>", dap.step_into, desc = "Debug: Step Into" },
				{ "<F2>", dap.step_over, desc = "Debug: Step Over" },
				{ "<F3>", dap.step_out, desc = "Debug: Step Out" },
				{ "<F9>", dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
				{
					"<leader>B",
					function()
						dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
					end,
					desc = "Debug: Set Breakpoint",
				},
				-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
				{ "<F7>", dapui.toggle, desc = "Debug: See last session result." },
				unpack(keys),
			}
		end,
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			require("mason-nvim-dap").setup({
				automatic_installation = true,
				handlers = {},
				ensure_installed = {
					"delve",
				},
			})

			-- Dap UI setup
			-- For more information, see |:help nvim-dap-ui|
			dapui.setup({
				-- Set icons to characters that are more likely to work in every terminal.
				--    Feel free to remove or use ones that you like more! :)
				--    Don't feel like these are good choices.
				icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
				controls = {
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "⏎",
						step_over = "⏭",
						step_out = "⏮",
						step_back = "b",
						run_last = "▶▶",
						terminate = "⏹",
						disconnect = "⏏",
					},
				},
			})

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Install golang specific config
			require("dap-go").setup({
				delve = {
					-- On Windows delve must be run attached or it crashes.
					-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
					detached = vim.fn.has("win32") == 0,
				},
			})

			require("dap-vscode-js").setup({
				-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
				debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
				-- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
				adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
				-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
				-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
				-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
			})

			require("dap.ext.vscode").load_launchjs(nil, { javascript = "js" })
			vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			vim.api.nvim_create_augroup("DAP_UI_RESET", { clear = true })

			local bufferNames = {}

			local nvimtreeApi = require("nvim-tree.api")
			local Event = nvimtreeApi.events.Event
			nvimtreeApi.events.subscribe(Event.TreeClose, function()
				if dap.session() then
					local buf_id = dapui.elements.repl.buffer()
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						-- Check if the buffer in the window matches the target buffer
						if vim.api.nvim_win_get_buf(win) == buf_id then
							dapui.open({ reset = true })
							break
						end
					end
				end
			end)

			local api = vim.api
			local keymap_restore = {}
			dap.listeners.after["event_initialized"]["me"] = function()
				for _, buf in pairs(api.nvim_list_bufs()) do
					local keymaps = api.nvim_buf_get_keymap(buf, "n")
					for _, keymap in pairs(keymaps) do
						if keymap.lhs == "K" or keymap.lhs == "<f24>" or keymap.lhs == "<F12>" then
							table.insert(keymap_restore, keymap)
							api.nvim_buf_del_keymap(buf, "n", "K")
						end
					end
				end
				api.nvim_set_keymap("n", "K", '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
				vim.keymap.set("n", "<F12>", function()
					dapui.toggle()
				end)
				--[[
        <f24> = <S-F12>
        When press Shift+12, the keystroke neovim receive is ^[[24;2~, which equivilent to <f24>
        To find the keystroke and which key associate with it:
        - Press Control+v then Shift+12 in the terminal to get the keystroke (^[[24;2~)
        - Using "nvim -V3log" then ":q" to get terminfo
        - Find the key associate with the keystroke
       ]]
				--
				vim.keymap.set("n", "<f24>", function()
					local i = 0
					while dap.session() ~= nil do
						i = i + 1
						if i >= 50 then
							break
						end
						dap.terminate()
						dap.close()
						dapui.close()
					end
				end, { silent = true })
			end

			dap.listeners.after["event_terminated"]["me"] = function()
				for _, keymap in pairs(keymap_restore) do
					if api.nvim_buf_is_valid(keymap.buffer) then
						api.nvim_buf_set_keymap(
							keymap.buffer,
							keymap.mode,
							keymap.lhs,
							keymap.lhs,
							{ silent = keymap.silent == 1 }
						)
					end
				end
				keymap_restore = {}
			end
		end,
	},
})
