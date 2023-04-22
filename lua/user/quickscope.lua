vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
vim.cmd([[
  highlight QuickScopePrimary guifg='#3b8eea' gui=bold ctermfg=155 cterm=bold
  highlight QuickScopeSecondary guifg='#f14c4c' gui=bold ctermfg=81 cterm=bold
]])
