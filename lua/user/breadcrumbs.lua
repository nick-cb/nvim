local M = {}

local icons = require('user.icons')
local kind = icons.kind

local config = {
  winbar_filetype_exclude = {
    "help",
    "startify",
    "dashboard",
    "lazy",
    "neo-tree",
    "neogitstatus",
    "NvimTree",
    "Trouble",
    "alpha",
    "lir",
    "Outline",
    "spectre_panel",
    "toggleterm",
    "DressingSelect",
    "Jaq",
    "harpoon",
    "dap-repl",
    "dap-terminal",
    "dapui_console",
    "dapui_hover",
    "lab",
    "notify",
    "noice",
    "neotest-summary",
    "",
  },
  options = {
    icons = {
      Array = kind.Array .. " ",
      Boolean = kind.Boolean .. " ",
      Class = kind.Class .. " ",
      Color = kind.Color .. " ",
      Constant = kind.Constant .. " ",
      Constructor = kind.Constructor .. " ",
      Enum = kind.Enum .. " ",
      EnumMember = kind.EnumMember .. " ",
      Event = kind.Event .. " ",
      Field = kind.Field .. " ",
      File = kind.File .. " ",
      Folder = kind.Folder .. " ",
      Function = kind.Function .. " ",
      Interface = kind.Interface .. " ",
      Key = kind.Key .. " ",
      Keyword = kind.Keyword .. " ",
      Method = kind.Method .. " ",
      Module = kind.Module .. " ",
      Namespace = kind.Namespace .. " ",
      Null = kind.Null .. " ",
      Number = kind.Number .. " ",
      Object = kind.Object .. " ",
      Operator = kind.Operator .. " ",
      Package = kind.Package .. " ",
      Property = kind.Property .. " ",
      Reference = kind.Reference .. " ",
      Snippet = kind.Snippet .. " ",
      String = kind.String .. " ",
      Struct = kind.Struct .. " ",
      Text = kind.Text .. " ",
      TypeParameter = kind.TypeParameter .. " ",
      Unit = kind.Unit .. " ",
      Value = kind.Value .. " ",
      Variable = kind.Variable .. " ",
    },
    highlight = true,
    separator = " " .. icons.ui.ChevronRight .. " ",
    depth_limit = 0,
    depth_limit_indicator = "..",
  },
}

M.setup = function()
  local status_ok, navic = pcall(require, "nvim-navic")
  if not status_ok then
    return
  end

  M.create_winbar()
  navic.setup(config.options)
end

local function isempty(s)
  return s == nil or s == ""
end
local function get_buf_option(opt)
  local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
  if not status_ok then
    return nil
  else
    return buf_option
  end
end

M.get_filename = function()
  local filename = vim.fn.expand "%:t"
  local extension = vim.fn.expand "%:e"

  if not isempty(filename) then
    local file_icon, hl_group
    local _, devicons = pcall(require, "nvim-web-devicons")
    file_icon, hl_group = devicons.get_icon(filename, extension, { default = true })

    if isempty(file_icon) then
      file_icon = icons.kind.File
    end

    local buf_ft = vim.bo.filetype

    if buf_ft == "dapui_breakpoints" then
      file_icon = icons.ui.Bug
    end

    if buf_ft == "dapui_stacks" then
      file_icon = icons.ui.Stacks
    end

    if buf_ft == "dapui_scopes" then
      file_icon = icons.ui.Scopes
    end

    if buf_ft == "dapui_watches" then
      file_icon = icons.ui.Watches
    end

    -- if buf_ft == "dapui_console" then
    --   file_icon = lvim.icons.ui.DebugConsole
    -- end

    local navic_text = vim.api.nvim_get_hl_by_name("Normal", true)
    vim.api.nvim_set_hl(0, "Winbar", { fg = navic_text.foreground })

    return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#Winbar#" .. filename .. "%*"
  end
end

local get_gps = function()
  local status_gps_ok, gps = pcall(require, "nvim-navic")
  if not status_gps_ok then
    return ""
  end

  local status_ok, gps_location = pcall(gps.get_location, {})
  if not status_ok then
    return ""
  end

  if not gps.is_available() or gps_location == "error" then
    return ""
  end

  if not isempty(gps_location) then
    return "%#NavicSeparator#" .. icons.ui.ChevronRight .. "%* " .. gps_location
  else
    return ""
  end
end

local excludes = function()
  return vim.tbl_contains(config.winbar_filetype_exclude or {}, vim.bo.filetype)
end

M.get_winbar = function()
  if excludes() then
    return
  end
  local value = M.get_filename()

  local gps_added = false
  if not isempty(value) then
    local gps_value = get_gps()
    value = value .. " " .. gps_value
    if not isempty(gps_value) then
      gps_added = true
    end
  end

  if not isempty(value) and get_buf_option "mod" then
    -- TODO: replace with circle
    local mod = "%#LspCodeLens#" .. icons.ui.Circle .. "%*"
    if gps_added then
      value = value .. " " .. mod
    else
      value = value .. mod
    end
  end

  local num_tabs = #vim.api.nvim_list_tabpages()

  if num_tabs > 1 and not isempty(value) then
    local tabpage_number = tostring(vim.api.nvim_tabpage_get_number(0))
    value = value .. "%=" .. tabpage_number .. "/" .. tostring(num_tabs)
  end

  local status_ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
  if not status_ok then
    return
  end
end

M.create_winbar = function()
  vim.api.nvim_create_augroup("_winbar", {})
  vim.api.nvim_create_autocmd({
    "CursorHoldI",
    "CursorHold",
    "BufWinEnter",
    "BufFilePost",
    "InsertEnter",
    "BufWritePost",
    "TabClosed",
    "TabEnter",
  }, {
    group = "_winbar",
    callback = function()
      local status_ok, _ = pcall(vim.api.nvim_buf_get_var, 0, "lsp_floating_window")
      if not status_ok then
        -- TODO:
        require("user.breadcrumbs").get_winbar()
      end
    end,
  })
end

return M
