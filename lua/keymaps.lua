vim.g.mapleader = " "

vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "No Highlight" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "vv", "V")
vim.keymap.set("n", "V", "v$")

vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", "!", "!<c-g>u")
vim.keymap.set("i", "?", "?<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")
vim.keymap.set("i", "<space>", "<space><c-g>u")

vim.keymap.set("i", "<C-l>", "<Right>")
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-k>", "<Up>")
vim.keymap.set("i", "<C-j>", "<Down>")

vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-l>", "<c-w>l")

vim.keymap.set("n", "<c-j>", "<c-w><c-w>")
vim.keymap.set("n", "<c-k>", "<c-w><s-w>")

vim.keymap.set("c", "<c-j>", 'pumvisible() ? "\\<c-n>" : "\\<c-j>"', { expr = true, noremap = true })
vim.keymap.set("c", "<c-k>", 'pumvisible() ? "\\<c-p>" : "\\<c-k>"', { expr = true, noremap = true })

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("x", "∆", ":m '>+1<CR>gv-gv")
vim.keymap.set("x", "˚", ":m '<-2<CR>gv-gv")
vim.keymap.set("n", "∆", ":m .+1<CR>==")
vim.keymap.set("n", "˚", ":m .-2<CR>==")

vim.keymap.set("t", "<c-h>", "<c-\\><c-n><c-w>h")
vim.keymap.set("t", "<c-j>", "<c-\\><c-n><c-w>j")
vim.keymap.set("t", "<c-k>", "<c-\\><c-n><c-w>k")
vim.keymap.set("t", "<c-l>", "<c-\\><c-n><c-w>l")

vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "delete current buffer" })

-- vim.keymap.set("n", "<leader><TAB>", "<cmd>lua require('telescope-tabs').list_tabs()<cr>", { desc = "list tabs" })

-- vim.api.nvim_create_user_command("Redir", function(ctx)
-- 	local lines = vim.split(vim.api.nvim_exec(ctx.args, true), "\n", { plain = true })
-- 	vim.cmd("new")
-- 	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
-- 	vim.opt_local.modified = false
-- end, { nargs = "+", complete = "command" })
