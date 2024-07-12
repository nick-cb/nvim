local icons = require("user.icons")

local M = {}

M.compare_revision = function()
	local ok_builtin, builtin = pcall(require, "telescope.builtin")
	local ok_actions, actions = pcall(require, "telescope.actions")
	local ok_state, actions_state = pcall(require, "telescope.actions.state")

	if ok_builtin and ok_actions and ok_state then
		builtin.git_bcommits({
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = actions_state.get_selected_entry()
					vim.fn.execute("Gitsigns diffthis " .. selection.value)
				end)
				return true
			end,
		})
	end
end

local Layout = require("nui.layout")
local Popup = require("nui.popup")

local function make_popup(options)
	local TSLayout = require("telescope.pickers.layout")
	local popup = Popup(options)
	function popup.border:change_title(title)
		popup.border.set_text(popup.border, "top", title)
	end

	return TSLayout.Window(popup)
end

local previewers = require("telescope.previewers")
local Job = require("plenary.job")
local ingore_file_type = function(filepath, bufnr, opts)
	filepath = vim.fn.expand(filepath)
	Job:new({
		command = "file",
		args = { "--mime-type", "-b", filepath },
		on_exit = function(j)
			local mime_type = vim.split(j:result()[1], "/")[1]
			if mime_type == "text" then
				previewers.buffer_previewer_maker(filepath, bufnr, opts)
			else
				-- maybe we want to write something to the buffer here
				vim.schedule(function()
					vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
				end)
			end
		end,
	}):sync()
end

M.setup = function()
	local telescope = require("telescope")
	local actions = require("telescope.actions")

	telescope.setup({
		defaults = {
      preview = {
        filesize_limit = 0.1,
      },
			prompt_prefix = icons.ui.Telescope .. " ",
			selection_caret = icons.ui.Forward .. " ",
			entry_prefix = "  ",
			initial_mode = "normal",
			selection_strategy = "reset",
			layout_strategy = "flex",
      borderchars = {'─', '│', '─', '│', '┌', '┐', '┘', '└'},
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden",
				"--glob=!.git/",
        "--glob=!node_modules/",
        "--glob=!_js_libs.ejs",
        "--glob=!statics/",
			},
			mappings = {
				i = {
					["<C-n>"] = actions.cycle_history_next,
					["<C-p>"] = actions.cycle_history_prev,
					["<C-c>"] = actions.close,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<C-q>"] = function(...)
						actions.smart_send_to_qflist(...)
						actions.open_qflist(...)
					end,
					["<CR>"] = actions.select_default,
				},
				n = {
					["<C-n>"] = actions.move_selection_next,
					["<C-p>"] = actions.move_selection_previous,
					["<C-q>"] = function(...)
						actions.smart_send_to_qflist(...)
						actions.open_qflist(...)
					end,
					["q"] = actions.close,
				},
			},
			path_display = { "smart" },
			winblend = 0,
			border = {},
			color_devicons = true,
			set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
			buffer_previewer_maker = ingore_file_type,
		},
		pickers = {
		  find_files = {
		--     hidden = true,
		--     theme = "dropdown",
		    initial_mode = "insert",
        find_command = {
          "rg",
          "--files",
          "--hidden",
          "--glob=!**/.git/*",
          "--glob=!**/node_modules/*",
          -- "--glob=!**/_js_libs/*",
          "--glob=!**/statics/assets/*",
        }
		  },
		  live_grep = {
		    --@usage don't include the filename in the search results
		    only_sort_text = true,
		    initial_mode = "insert",
		  },
		  grep_string = {
		    only_sort_text = true,
		    initial_mode = "insert",
		  },
		--   buffers = {
		--     initial_mode = "normal",
		--     mappings = {
		--       i = {
		--         ["<C-d>"] = actions.delete_buffer,
		--       },
		--       n = {
		--         ["dd"] = actions.delete_buffer,
		--       },
		--     },
		--   },
		--   planets = {
		--     show_pluto = true,
		--     show_moon = true,
		--   },
		--   git_files = {
		--     hidden = true,
		--     show_untracked = true,
		--   },
		  colorscheme = {
		    enable_preview = true,
		  },
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
			advanced_git_search = {
				diff_plugin = "fugitive",
				-- customize git in previewer
				-- e.g. flags such as { "--no-pager" }, or { "-c", "delta.side-by-side=false" }
				git_flags = {},
				-- customize git diff in previewer
				-- e.g. flags such as { "--raw" }
				git_diff_flags = {},
				-- Show builtin git pickers when executing "show_custom_functions" or :AdvancedGitSearch
				show_builtin_git_pickers = false,
			},
		},
		file_ignore_patterns = {
			"vendor/*",
			"%.lock",
			"yarn.lock",
			"__pycache__/*",
			"%.sqlite3",
			"%.ipynb",
			"node_modules/*",
			"%.jpg",
			"%.jpeg",
			"%.png",
			"%.svg",
			"%.otf",
			"%.ttf",
			".git/",
			".git/*",
			"%.webp",
			".dart_tool/",
			".github/",
			".gradle/",
			".idea/",
			".settings/",
			".vscode/",
			"__pycache__/",
			"build/",
			"env/",
			"gradle/",
			"node_modules/",
			"target/",
			"%.pdb",
			"%.dll",
			"%.class",
			"%.exe",
			"%.cache",
			"%.ico",
			"%.pdf",
			"%.dylib",
			"%.jar",
			"%.docx",
			"%.met",
			"smalljre_*/*",
			".vale/",
      "_js_libs",
      "statics/assets/"
		},
	})

	pcall(require("telescope").load_extension, "fzf")
end

return M
