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
