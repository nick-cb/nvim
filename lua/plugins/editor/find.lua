return {
	{
		"dmtrKovalenko/fff.nvim",
		build = function()
			require("fff.download").download_or_build_binary()
		end,
		opts = {
			debug = {
				enabled = true,
				show_scores = true,
			},
			layout = {
				height = 0.9,
				width = 0.9,
				prompt_position = "top",
				preview_position = "right",
				preview_size = 0.6,
				show_scrollbar = true,
			},
			keymaps = {
				close = "<c-q>",
			},
		},
		lazy = false,
		keys = {
			{
				"<space>sf",
				function()
					require("fff").find_files()

					vim.schedule(function()
						local input_buf = require("fff.picker_ui").state.input_buf
						if input_buf then
							vim.keymap.set("n", "j", require("fff.picker_ui").move_down, { buffer = input_buf })
							vim.keymap.set("n", "k", require("fff.picker_ui").move_up, { buffer = input_buf })
							vim.keymap.set("n", "<Esc>", require("fff.picker_ui").close, { buffer = input_buf })
							vim.keymap.set(
								"n",
								"<C-u>",
								require("fff.picker_ui").scroll_preview_up,
								{ buffer = input_buf }
							)
							vim.keymap.set(
								"n",
								"<C-u>",
								require("fff.picker_ui").scroll_preview_up,
								{ buffer = input_buf }
							)
							vim.keymap.set("n", "<C-s>", function()
								require("fff.picker_ui").select("split")
							end, { buffer = input_buf })
							vim.keymap.set("n", "<C-v>", function()
								require("fff.picker_ui").select("vsplit")
							end, { buffer = input_buf })
							vim.keymap.set("n", "<CR>", function()
								require("fff.picker_ui").select()
							end, { buffer = input_buf })
						end
					end)
				end,
				desc = "FFFind files",
			},
		},
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		opts = {
			keymap = {
				builtin = {
					["<C-d>"] = "preview-page-down",
					["<C-u>"] = "preview-page-up",
				},
			},
		},
	},
	{
		"nick-cb/rgflow.nvim",
		config = function()
			require("rgflow").setup({
				cmd_flags = "--smart-case --fixed-strings --ignore --max-columns 200",
				default_trigger_mappings = true,
				default_ui_mappings = true,
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
	{
		"A7Lavinraj/fyler.nvim",
		dependencies = { "nvim-mini/mini.icons" },
		branch = "stable",
		lazy = false,
		opts = {
			views = {
				finder = {
					close_on_select = false,
					mappings = {
						["<c-l>"] = "Select",
						["<c-h>"] = "CollapseNode",
						["<c-v>"] = "SelectVSplit",
						["<c-x>"] = "SelectSplit",
					},
					win = {
						kinds = {
							split_left = {
								width = "15%",
							},
							split_left_most = {
								width = "15%",
							},
						},
					},
				},
			},
		},
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
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = { "GrugFar", "GrugFarWithin" },
    keys = {
      {
        "<c-f>",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "x" },
        desc = "Search and Replace",
      },
    },
  },
}
