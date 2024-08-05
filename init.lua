require("options")
require('user.quickscope')
require("plugins")
require('autocmds')
require("keymaps")
vim.cmd([[colorscheme darkplus]])

-- require("luasnip.loaders.from_vscode").lazy_load({
--   paths = {
--     "/Users/nick/.local/share/nvim/lazy/vscode-es7-javascript-react-snippets/",
--   },
-- })
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
  ['@tag.builtin.tsx'] = '@keyword',
  -- ['@lsp.typemod.variable.readonly.typescriptreact'] = '@constant.tsx'
  ['@tag.tsx'] = '@type.tsx',
  ['@keyword.import.tsx'] = 'Include',
  ['@keyword.export.tsx'] = 'Include',
  ['@keyword.import.typescript'] = 'Include',
  ['@keyword.export.typescript'] = 'Include',
  ['@lsp.typemod.variable.readonly.typescriptreact'] = 'Constant',
  ['@lsp.typemod.variable.readonly.typescript'] = 'Constant',
  ['@keyword.exception.typescript'] = 'Include',
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

-- vim.cmd[[
--   if exists('+termguicolors')
--     let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
--     let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
--     set termguicolors
--   endif
-- ]]
--
local ts = require('nvim-treesitter')
local lsp = vim.lsp

local function get_call_expressions()
  local file = io.open("/Users/nick/workspaces/be-gateway/app.js", "r");
  if file == nil then
    return
  end
  local source_code = file:read("*all")
  file:close()
  local parser = vim.treesitter.get_string_parser(source_code, "javascript")
  local tree = parser:parse(source_code)[1]
  local query = vim.treesitter.query.parse("javascript", [[
    (call_expression
      function: (member_expression
        object: (identifier) @object (#eq? @object "app")
        property: (property_identifier) @property (#eq? @property "use"))
      arguments: (arguments
        (string) @route
        (identifier)* @handlers
      )) @expression
  ]]);

  local matches = query:iter_captures(tree:root(), source_code)

  local endpoints = {}
  for id, node in matches do
    local capture_name = query.captures[id];
    local root_endpoint = {name = '', handlers = {}}
    if capture_name == 'route' then
      local route = vim.treesitter.get_node_text(node, source_code):gsub('"', '')
      root_endpoint.name = route
    end
    if capture_name == 'handlers' then
      local start_r, start_col, _, _ = vim.treesitter.get_node_range(node)
      local params = { textDocument = vim.lsp.util.make_text_document_params(), position = { line = start_r, character = start_col } }
      local handler_definitions = lsp.buf_request_sync(0, 'textDocument/definition', params)
      for _, result in pairs(handler_definitions or {}) do
        for _, definition in pairs(result.result or {}) do
          local handler_file = io.open(vim.uri_to_fname(definition.targetUri):gsub(" ", ""), "r");
          if handler_file == nil then
            goto continue
          end
          local handler_source = handler_file:read("*all")
          handler_file:close()
          local handler_file_parser = vim.treesitter.get_string_parser(handler_source, "javascript")
          local handler_file_tree = handler_file_parser:parse(handler_source)[1]
          local handler_query = vim.treesitter.query.parse("javascript", [[
              (call_expression
                function: (member_expression
                  object: (identifier) @object (#eq? @object "router")
                  property: (property_identifier) @property (#any-of? @property "get" "post" "put" "delete"))
                arguments: (arguments
                  (string) @route
                  (member_expression
                    object: (identifier) @controller (#match? @controller "\\w+Controller")
                    property: (property_identifier) @handler)
              )) @expression
          ]]);

          local handler_matches = handler_query:iter_captures(handler_file_tree:root(), handler_source)

          local handler_endpoints = {}
          for handler_id, handler_node in handler_matches do
            local handler_capture_name = handler_query.captures[handler_id];
            local handler_endpoint = {name = ''}

            if handler_capture_name == 'route' then
              handler_endpoint.name = vim.treesitter.get_node_text(handler_node, handler_source):gsub("'", '')
              table.insert(handler_endpoints, handler_endpoint)
            end
            -- vim.print(handler_endpoint)
            if handler_endpoint.name ~= '' then
              table.insert(handler_endpoints, handler_endpoint)
            end
          end

          table.insert(root_endpoint.handlers, handler_endpoints)

          ::continue::
        end
      end
    end

    if root_endpoint.name ~= '' then
      table.insert(endpoints, root_endpoint)
    end
  end
  vim.print(endpoints)

  -- vim.print(endpoints)
  -- local conf = require("telescope.config").values
  -- pickers.new({}, {
  --   promt_title = "Endpoints",
  --   finder = finders.new_table({
  --     results = endpoints,
  --     entry_maker = function(entry)
  --       return {
  --         value = entry,
  --         display = entry,
  --         ordinal = entry,
  --       }
  --     end,
  --   }),
  --   sorter = conf.generic_sorter({}),
  -- }):find()
end

vim.cmd([[
  set rtp+=/opt/homebrew/opt/fzf
]])
-- vim.api.nvim_create_autocmd('LspNotify', {
--   callback = function(args)
--     local bufnr = args.buf
--     local data = args.data
--     vim.print({bufnr, data})
--     -- local client_id = args.data.client_id
--     -- local method = args.data.method
--     -- local params = args.data.params

--     -- vim.print({bufnr, client_id, method, params})
--     -- local workspaceFolder = params.workspaceFolder
--     -- local uri = workspaceFolder.uri
--   end,
-- })


-- vim.api.nvim_create_autocmd('LspRequest', {
--   callback = function (args)
--     local bufnr = args.bufnr
--     local data = args.data
--     vim.print({args})
--     -- if args.data.request.type == 'complete' then
--     --   vim.print({bufnr = bufnr, data = data})
--     -- end
--   end
-- })

-- vim.api.nvim_create_autocmd("LspTokenUpdate", {
--   callback = function (args)
--     local bufnr = args.bufnr
--     local data = args.data
--     vim.print({bufnr = bufnr, data = data})
--   end
-- })
