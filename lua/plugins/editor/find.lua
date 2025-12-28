local icons = require("icons");

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
				preview_position = function()
          -- Change preview position based on terminal width
          return vim.o.columns >= 120 and 'right' or 'bottom'
        end,
				preview_size = 0.6,
				show_scrollbar = true,
			},
      preview = {
        line_numbers = true,
      },
			keymaps = {
				close = "<c-q>",
			},
      hl = {
        directory_path = "Variable",
        normal = "Type",
      }
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
							vim.keymap.set( "n", "<C-u>", require("fff.picker_ui").scroll_preview_up, { buffer = input_buf })
							vim.keymap.set( "n", "<C-u>", require("fff.picker_ui").scroll_preview_up, { buffer = input_buf })
							vim.keymap.set("n", "<C-s>", function() require("fff.picker_ui").select("split") end, { buffer = input_buf })
              vim.keymap.set("n", "<C-v>", function() require("fff.picker_ui").select("vsplit") end, { buffer = input_buf })
							vim.keymap.set("n", "<CR>", function() require("fff.picker_ui").select() end, { buffer = input_buf })
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
          true,
					["<C-d>"] = "preview-page-down",
					["<C-u>"] = "preview-page-up",
				},
        fzf = {
          true,
					["ctrl-d"] = "preview-page-down",
					["ctrl-u"] = "preview-page-up",
        }
			},
      winopts = {
        height = 0.9,
        width = 0.9,
        backdrop = 100,
        border = "single"
      }
		},
    keys = {
      { "<leader>gd", "<cmd>FzfLua git_bcommits<cr>" }
    }
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
    enabled = false,
	},
	{
		"cbochs/grapple.nvim",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", lazy = true },
		},
		opts = {
			scope = "git_branch",
			icons = true,
			quick_select = "123456789",
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
  {
		"kyazdani42/nvim-tree.lua",
    opts = {
      on_attach = function (bufnr)
        local api = require('nvim-tree.api')
        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        vim.keymap.set('n', "l", api.node.open.edit, opts("Open: In Place"))
        vim.keymap.set('n', "<CR>", api.node.open.edit, opts("Open: In Place"))
        vim.keymap.set('n', "h", api.node.navigate.parent_close, opts("Close parent folder"))
        vim.keymap.set('n', "v", api.node.open.vertical, opts("Open vertical split"))

        vim.keymap.set('n', "C", api.tree.change_root_to_node, opts("CD"))
        vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
        vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
        vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts('Info'))
        vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
        vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
        vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
        vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
        vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
        vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open Preview'))
        vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts('Next Sibling'))
        vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling'))
        vim.keymap.set('n', '.', api.node.run.cmd, opts('Run Command'))
        vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
        vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
        vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
        vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts('Toggle No Buffer'))
        vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
        vim.keymap.set('n', 'C', api.tree.toggle_git_clean_filter, opts('Toggle Git Clean'))
        vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
        vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git'))
        vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
        vim.keymap.set('n', 'D', api.fs.trash, opts('Trash'))
        vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))
        vim.keymap.set('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
        vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
        vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
        vim.keymap.set('n', 'F', api.live_filter.clear, opts('Clean Filter'))
        vim.keymap.set('n', 'f', api.live_filter.start, opts('Filter'))
        vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
        vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
        vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
        vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
        vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling'))
        vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts('First Sibling'))
        vim.keymap.set('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))
        vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
        vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
        vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
        vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
        vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
        vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
        vim.keymap.set('n', 's', api.node.run.system, opts('Run System'))
        vim.keymap.set('n', 'S', api.tree.search_node, opts('Search'))
        vim.keymap.set('n', 'U', api.tree.toggle_custom_filter, opts('Toggle Hidden'))
        vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse'))
        vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
        vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
        vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
        vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
      end,
      auto_reload_on_write = false,
      sync_root_with_cwd = true,
      view = {
        width = 35,
      },
      renderer = {
        highlight_git = true,
        root_folder_label = ":t",
        icons = {
          webdev_colors = true,
          padding = " ",
          glyphs = {
            default = icons.ui.Text,
            symlink = icons.ui.FileSymlink,
            bookmark = icons.ui.BookMark,
            folder = {
              arrow_closed = icons.ui.TriangleShortArrowRight,
              arrow_open = icons.ui.TriangleShortArrowDown,
              default = icons.ui.Folder,
              open = icons.ui.FolderOpen,
              empty = icons.ui.EmptyFolder,
              empty_open = icons.ui.EmptyFolderOpen,
              symlink = icons.ui.FolderSymlink,
              symlink_open = icons.ui.FolderOpen,
            },
            git = {
              unstaged = icons.git.FileUnstaged,
              staged = icons.git.FileStaged,
              unmerged = icons.git.FileUnmerged,
              renamed = icons.git.FileRenamed,
              untracked = icons.git.FileUntracked,
              deleted = icons.git.FileDeleted,
              ignored = icons.git.FileIgnored,
            },
          },
        },
      },
      hijack_directories = {
        enable = false,
      },
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      diagnostics = {
        enable = true,
        debounce_delay = 50,
        icons = {
          hint = icons.diagnostics.BoldHint,
          info = icons.diagnostics.BoldInformation,
          warning = icons.diagnostics.BoldWarning,
          error = icons.diagnostics.BoldError,
        },
      },
      filters = {
        custom = { "node_modules", "\\.cache" },
      },
      filesystem_watchers = {
        ignore_dirs = {},
      },
      git = {
        ignore = false,
        timeout = 200,
      },
      actions = {
        open_file = {
          resize_window = false,
          window_picker = {
            exclude = {
              filetype = { "notify", "lazy", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
      },
      trash = {
        cmd = "trash",
        require_confirm = true,
      },
      system_open = {
        cmd = nil,
      },
    },
		cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
		event = "User DirOpened",
  }
}
