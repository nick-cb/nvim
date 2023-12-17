local icons = require('user.icons')

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
          print(vim.inspect(prompt_bufnr))
          vim.fn.execute("Gitsigns diffthis " .. selection.value)
        end)
        return true
      end,
    })
  end
end

local Layout = require("nui.layout")
local Popup = require("nui.popup")
local TSLayout = require("telescope.pickers.layout")

local function make_popup(options)
  local popup = Popup(options)
  function popup.border:change_title(title)
    popup.border.set_text(popup.border, "top", title)
  end

  return TSLayout.Window(popup)
end

M.setup = function()
  local telescope = require("telescope")
  local actions = require("telescope.actions")

  telescope.setup({
    defaults = {
      prompt_prefix = icons.ui.Telescope .. " ",
      selection_caret = icons.ui.Forward .. " ",
      entry_prefix = "  ",
      initial_mode = "normal",
      selection_strategy = "reset",
      layout_strategy = "flex",
      layout_config = {
        horizontal = {
          size = {
            width = "80%",
            height = "70%",
          },
          -- height = 0.9,
          -- preview_cutoff = 120,
          -- prompt_position = "bottom",
          -- width = 0.8,
          -- preview_width = 0.6
        },
        vertical = {
          size = {
            width = "90%",
            height = "90%",
          },
          -- height = 0.9,
          -- preview_cutoff = 40,
          -- prompt_position = "bottom",
          -- width = 0.8,
        },
        -- center = {
        --   height = 0.4,
        --   preview_cutoff = 40,
        --   prompt_position = "top",
        --   width = 0.5
        -- },
      },
      create_layout = function(picker)
        local border = {
          results = {
            top_left = "┌",
            top = "─",
            top_right = "┬",
            right = "│",
            bottom_right = "",
            bottom = "",
            bottom_left = "",
            left = "│",
          },
          results_patch = {
            minimal = {
              top_left = "┌",
              top_right = "┐",
            },
            horizontal = {
              top_left = "┌",
              top_right = "┬",
            },
            vertical = {
              top_left = "├",
              top_right = "┤",
            },
          },
          prompt = {
            top_left = "├",
            top = "─",
            top_right = "┤",
            right = "│",
            bottom_right = "┘",
            bottom = "─",
            bottom_left = "└",
            left = "│",
          },
          prompt_patch = {
            minimal = {
              bottom_right = "┘",
            },
            horizontal = {
              bottom_right = "┴",
            },
            vertical = {
              bottom_right = "┘",
            },
          },
          preview = {
            top_left = "┌",
            top = "─",
            top_right = "┐",
            right = "│",
            bottom_right = "┘",
            bottom = "─",
            bottom_left = "└",
            left = "│",
          },
          preview_patch = {
            minimal = {},
            horizontal = {
              bottom = "─",
              bottom_left = "",
              bottom_right = "┘",
              left = "",
              top_left = "",
            },
            vertical = {
              bottom = "",
              bottom_left = "",
              bottom_right = "",
              left = "│",
              top_left = "┌",
            },
          },
        }

        local results = make_popup({
          focusable = false,
          border = {
            style = border.results,
            text = {
              top = picker.results_title,
              top_align = "center",
            },
          },
          -- win_options = {
          --   winhighlight = "Normal:Normal",
          -- },
        })

        local prompt = make_popup({
          enter = true,
          border = {
            style = border.prompt,
            text = {
              top = picker.prompt_title,
              top_align = "center",
            },
          },
          -- win_options = {
          --   winhighlight = "Normal:Normal",
          -- },
        })

        local preview = make_popup({
          focusable = false,
          border = {
            style = border.preview,
            text = {
              top = picker.preview_title,
              top_align = "center",
            },
          },
        })

        local box_by_kind = {
          vertical = Layout.Box({
            Layout.Box(preview, { grow = 1 }),
            Layout.Box(results, { grow = 1 }),
            Layout.Box(prompt, { size = 3 }),
          }, { dir = "col" }),
          horizontal = Layout.Box({
            Layout.Box({
              Layout.Box(results, { grow = 1 }),
              Layout.Box(prompt, { size = 3 }),
            }, { dir = "col", size = "40%" }),
            Layout.Box(preview, { size = "60%" }),
          }, { dir = "row" }),
          minimal = Layout.Box({
            Layout.Box(results, { grow = 1 }),
            Layout.Box(prompt, { size = 3 }),
          }, { dir = "col" }),
        }

        local function get_box()
          local strategy = picker.layout_strategy
          if strategy == "vertical" or strategy == "horizontal" then
            return box_by_kind[strategy], strategy
          end

          local height, width = vim.o.lines, vim.o.columns
          local box_kind = "horizontal"
          if width < 100 then
            box_kind = "vertical"
            if height < 40 then
              box_kind = "minimal"
            end
          end
          return box_by_kind[box_kind], box_kind
        end

        local function prepare_layout_parts(layout, box_type)
          layout.results = results
          results.border:set_style(border.results_patch[box_type])

          layout.prompt = prompt
          prompt.border:set_style(border.prompt_patch[box_type])

          if box_type == "minimal" then
            layout.preview = nil
          else
            layout.preview = preview
            preview.border:set_style(border.preview_patch[box_type])
          end
        end

        local function get_layout_size(box_kind)
          return picker.layout_config[box_kind == "minimal" and "vertical" or box_kind].size
        end

        local box, box_kind = get_box()
        local layout = Layout({
          relative = "editor",
          position = "50%",
          size = get_layout_size(box_kind),
        }, box)

        layout.picker = picker
        prepare_layout_parts(layout, box_kind)

        local layout_update = layout.update
        function layout:update()
          local box, box_kind = get_box()
          prepare_layout_parts(layout, box_kind)
          layout_update(self, { size = get_layout_size(box_kind) }, box)
        end

        return TSLayout(layout)
      end,
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
      borderchars = nil,
      color_devicons = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    },
    pickers = {
      find_files = {
        hidden = true,
        theme = "dropdown",
        initial_mode = "insert",
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
      buffers = {
        initial_mode = "normal",
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },
          n = {
            ["dd"] = actions.delete_buffer,
          },
        },
      },
      planets = {
        show_pluto = true,
        show_moon = true,
      },
      git_files = {
        hidden = true,
        show_untracked = true,
      },
      colorscheme = {
        enable_preview = true,
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
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
    }
  })

  pcall(require("telescope").load_extension, "fzf")
end

return M
