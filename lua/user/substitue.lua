require("substitute").setup({})
vim.keymap.set("n", "s", "<cmd>lua require('substitute').operator({register = 'a'})<cr>", { noremap = true })
vim.keymap.set("n", "ss", "<cmd>lua require('substitute').line({register = 'a'})<cr>", { noremap = true })
vim.keymap.set("n", "S", "<cmd>lua require('substitute').eol({register = 'a'})<cr>", { noremap = true })
vim.keymap.set("x", "s", "<cmd>lua require('substitute').visual({register = 'a'})<cr>", { noremap = true })
vim.keymap.set("n", "sx", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
vim.keymap.set("n", "sxx", "<cmd>lua require('substitute.exchange').line()<cr>", { noremap = true })
vim.keymap.set("x", "X", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })
vim.keymap.set("n", "sxc", "<cmd>lua require('substitute.exchange').cancel()<cr>", { noremap = true })
