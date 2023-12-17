vim.g.mapleader = " "

vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "No Highlight" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<C-s>", ":SymbolsOutline<cr>")
vim.keymap.set("n", "<s-l>", ":BufferLineCycleNext<cr>")
vim.keymap.set("n", "<s-h>", ":BufferLineCyclePrev<cr>")

vim.keymap.set("n", "vv", "V")
vim.keymap.set("n", "V", "v$")

vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", "!", "!<c-g>u")
vim.keymap.set("i", "?", "?<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")
vim.keymap.set("i", "<space>", "<space><c-g>u")

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

-- lsp
vim.keymap.set("n", "<leader>e", "<CMD>Oil --float<CR>")
vim.keymap.set("n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>")
vim.keymap.set("n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
vim.keymap.set("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>")
vim.keymap.set("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>")
vim.keymap.set("n", "gr", "<cmd>Trouble lsp_references<cr>", { desc = "[g]oto [r]eferences" })

local format_filters = function(client)
  local filetype = vim.bo.filetype
  local n = require("null-ls")
  local s = require("null-ls.sources")
  local method = n.methods.formatting
  local available_formatters = s.get_available(filetype, method)

  if #available_formatters > 0 then
    return client.name == "null-ls"
  elseif client.supports_method("textdocument/formatting") then
    return true
  else
    return false
  end
end

local format_file = function(bufnr)
  local ok, comfort = pcall(require, "conform")
  if not ok then
    return
  end
  comfort.format({ bufnr })
  -- vim.lsp.buf.format({
  --   filter = format_filters,
  --   bufnr = bufnr,
  --   timeout = 30000,
  -- })
end

vim.keymap.set("n", "<space>lf", format_file)

vim.keymap.set("n", "<leader>sb", "<cmd>Telescope buffers<cr>", { desc = "[s]earch [b]uffers" })

vim.keymap.set("n", "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "[s]earch [f]iles" })
vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags theme=dropdown<cr>", { desc = "[s]earch [h]elp" })
vim.keymap.set("n", "<leader>st", "<cmd>Telescope live_grep theme=dropdown<cr>", { desc = "[s]earch by [g]rep" })

vim.keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches theme=dropdown<cr>", { desc = "[s]earch [b]ranchs" })
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits theme=dropdown<cr>", { desc = "[s]earch [c]ommit" })
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_bcommits theme=dropdown<cr>", { desc = "[c]check out" })
vim.keymap.set("n", "<leader>gg", "<cmd>lua require('user.toggleterm').lazygit_toggle()<cr>")
vim.keymap.set("n", "<leader>gd", "<cmd>lua require('user.telescope').compare_revision()<cr>")

vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseRight<cr>", { desc = "close all to the left" })
vim.keymap.set("n", "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", { desc = "close all to the left" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "delete current buffer" })
vim.keymap.set("n", "<leader>bD", "<cmd>:BufferLinePickClose<CR>", { desc = "pick buffer to close" })

-- vim.keymap.set("n", "<leader><TAB>", "<cmd>lua require('telescope-tabs').list_tabs()<cr>", { desc = "list tabs" })

vim.keymap.set("n", "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>",
  { desc = "Next Hunk" })
vim.keymap.set("n", "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>",
  { desc = "Prev Hunk" })
vim.keymap.set("n", "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", { desc = "Blame" })
vim.keymap.set("n", "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", { desc = "Preview Hunk" })
vim.keymap.set("n", "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", { desc = "Reset Hunk" })
vim.keymap.set("n", "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", { desc = "Reset Buffer" })
vim.keymap.set("n", "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", { desc = "Stage Hunk" })
vim.keymap.set("n", "<leader>gu",
  "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
  { desc = "Undo Stage Hunk" }
)

local harpoon = require("harpoon")
vim.keymap.set("n", "<leader>a", function()
  harpoon:list():append()
end)
vim.keymap.set("n", "<leader>ll", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<leader>ha", function()
  harpoon:list():select(1)
end)
vim.keymap.set("n", "<leader>hs", function()
  harpoon:list():select(2)
end)
vim.keymap.set("n", "<leader>hd", function()
  harpoon:list():select(3)
end)
vim.keymap.set("n", "<leader>hf", function()
  harpoon:list():select(4)
end)
