local M = {}

local config = {
  on_config_done = nil,
  ensure_installed = {},
  ignore_install = {},
  parser_install_dir = nil,
  sync_install = false,
  auto_install = true,
  matchup = {
    enable = false,
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = function(lang, buf)
      if vim.tbl_contains({ "latex" }, lang) then
        return true
      end

      local status_ok, big_file_detected = pcall(vim.api.nvim_buf_get_var, buf, "bigfile_disable_treesitter")
      return status_ok and big_file_detected
    end,
  },
  -- context_commentstring = {
  --   enable = true,
  --   enable_autocmd = false,
  --   config = {
  --     -- Languages that have a single comment style
  --     typescript = "// %s",
  --     css = "/* %s */",
  --     scss = "/* %s */",
  --     html = "<!-- %s -->",
  --     svelte = "<!-- %s -->",
  --     vue = "<!-- %s -->",
  --     json = "",
  --   },
  -- },
  indent = { enable = true, disable = { "yaml", "python" } },
  autotag = { enable = true },
  textobjects = {
    swap = {
      enable = false,
      -- swap_next = textobj_swap_keymaps,
    },
    -- move = textobj_move_keymaps,
    select = {
      enable = false,
      -- keymaps = textobj_sel_keymaps,
    },
  },
  textsubjects = {
    enable = false,
    keymaps = { ["."] = "textsubjects-smart", [";"] = "textsubjects-big" },
  },
  playground = {
    enable = false,
    disable = {},
    updatetime = 25,       -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },
  rainbow = {
    enable = false,
    extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
    max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
  },
}

M.setup = function()
  vim.g.skip_ts_context_commentstring_module = true
  local ts_ok, ts = pcall(require, "nvim-treesitter.configs")
  if not ts_ok then
    return
  end

  ts.setup(config)

  local ts_utils = require('nvim-treesitter.ts_utils')
  ts_utils.is_in_node_range = vim.treesitter.is_in_node_range
  ts_utils.get_node_range = vim.treesitter.get_node_range

  require("ts_context_commentstring").setup({
    enable_autocmd = false,
    commentary_integration = {},
    config = {

    },
    languages = {
      typescript = "// %s",
      css = "/* %s */",
      scss = "/* %s */",
      html = "<!-- %s -->",
      svelte = "<!-- %s -->",
      vue = "<!-- %s -->",
      json = "",
    }
  })
  vim.g.skip_ts_context_commentstring_module = true
end

return M
