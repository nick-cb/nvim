require("options")
require('user.quickscope')
require("plugins")
require('autocmds')
require("keymaps")

require("luasnip.loaders.from_vscode").lazy_load({
  paths = {
    "/Users/nick/.local/share/nvim/lazy/vscode-es7-javascript-react-snippets/",
  },
})
local links = {
  ['@lsp.type.namespace'] = '@namespace',
  ['@lsp.type.type'] = '@type',
  ['@lsp.type.class'] = '@type',
  ['@lsp.type.enum'] = '@type',
  ['@lsp.type.interface'] = '@type',
  ['@lsp.type.struct'] = '@structure',
  ['@lsp.type.parameter'] = '@parameter',
  ['@lsp.type.variable'] = '@variable',
  ['@lsp.type.property'] = '@property',
  ['@lsp.type.enumMember'] = '@constant',
  ['@lsp.type.function'] = '@function',
  ['@lsp.type.method'] = '@method',
  ['@lsp.type.macro'] = '@macro',
  ['@lsp.type.decorator'] = '@function',
  ['@lsp.typemod.variable.readonly.typescriptreact'] = '@constant.tsx'
}
for newgroup, oldgroup in pairs(links) do
  vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
end

local function get_project_root()
  local git_dir = vim.fn.finddir('.git', '.;')
  if git_dir ~= '' then
    return vim.fn.fnamemodify(git_dir, ':p:h:h')
  else
    return ''
  end
end

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local action_state = require("telescope.actions.state")
local actions = require('telescope.actions')
local Path = require('plenary.path')

local project_file = vim.fn.stdpath('data') .. '/projects.json'
local function shortest_unique_path(path, list)
  local p = Path:new(path)
  local parts = p:_split()

  for i = #parts, 1, -1 do
    local subpath = table.concat(parts, '/', i)
    local exists = vim.tbl_contains(list, subpath)
    if not exists then
      return subpath
    end
  end

  return path -- return the full path if all subpaths are in the list
end

local function create_finder(projects, current_dir)
  local entries = {}

  for _, project in ipairs(projects) do
    table.insert(entries, {
      value = project,
      display = project.name,
      ordinal = project.name,
      added_at = project.added_at,
    })
  end
  return finders.new_table({
    results = entries,
    entry_maker = function(entry)
      if entry.value.path == current_dir then
        return {
          value = entry,
          display = '* ' .. entry.display,
          ordinal = entry.ordinal,
          added_at = entry.added_at,
        }
      end
      return {
        value = entry,
        display = entry.display,
        ordinal = entry.ordinal,
        added_at = entry.added_at,
      }
    end,
  })
end

function GET_PROJECT()
  local current_dir = get_project_root()
  local projects = vim.fn.json_decode(vim.fn.readfile(project_file)) or {}

  local project_path = get_project_root()
  local p = Path:new(project_path)
  local parts = p:_split()
  local project_name = parts[#parts]
  local current_tab = vim.api.nvim_get_current_tabpage()
  local current_win = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(current_win)
  local current_buf = vim.api.nvim_get_current_buf()
  local file_path = vim.fn.expand('%:p')
  local current_time = os.time()

  pickers.new({}, {
    finder = create_finder(projects, current_dir),
    sorter = sorters.get_fuzzy_file(),
    attach_mappings = function(prompt_bufnr, map)
      map('n', 'pr', function()

        local exist = false
        for _, project in ipairs(projects) do
          if project.name == project_name then
            exist = true
            break
          end
        end

        if exist then
          return
        end

        table.insert(projects, {
          name = project_name,
          path = project_path,
          file = file_path,
          added_at = current_time,
          cursor = cursor_pos,
          bufrn = current_buf,
          winnr = current_win,
          tabnr = current_tab,
        })

        Path:new(project_file):write(vim.fn.json_encode(projects), 'w')

        local picker = action_state.get_current_picker(prompt_bufnr)
        local finder = create_finder(projects, current_dir)

        picker:refresh(finder, { reset_prompt = true })
      end)
      -- map('i', '<CR>', actions.set_selected)
      -- map('i', '<C-x>', actions.close)
      return true
    end,
  }):find()
end

-- require("luasnip.loaders.from_vscode").lazy_load({
-- 	paths = {
-- 		"/home/nick/.local/share/lunarvim/site/pack/packer/opt/awesome-flutter-snippets/",
-- 	},
-- })
-- vim.cmd[[
--   if exists('+termguicolors')
--     let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
--     let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
--     set termguicolors
--   endif
-- ]]
