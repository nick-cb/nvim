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

M.setup = function()
  local telescope = require("telescope")
  local actions = require("telescope.actions")

  telescope.setup({
      defaults = {
          prompt_prefix = icons.ui.Telescope .. " ",
          selection_caret = icons.ui.Forward .. " ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          layout_strategy = nil,
          layout_config = {},
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
          },
          live_grep = {
              --@usage don't include the filename in the search results
              only_sort_text = true,
          },
          grep_string = {
              only_sort_text = true,
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
              fuzzy = true, -- false will only do exact matching
              override_generic_sorter = true, -- override the generic sorter
              override_file_sorter = true, -- override the file sorter
              case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          },
      },
  })

  pcall(require("telescope").load_extension, "fzf")
end

return M
