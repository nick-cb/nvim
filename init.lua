vim.opt.backup = false -- creates a backup file
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.cmdheight = 1 -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.hlsearch = true -- highlight all matches on previous search pattern
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.mouse = "a" -- allow the mouse to be used in neovim
vim.opt.pumheight = 10 -- pop up menu height
vim.opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 0 -- always show tabs
vim.opt.smartcase = true -- smart case
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false -- creates a swapfile
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 100 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true -- enable persistent undo
vim.opt.updatetime = 300 -- faster completion (4000ms default)
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2 -- insert 2 spaces for a tab
vim.opt.cursorline = true -- highlight the current line
vim.opt.number = true -- set numbered lines
vim.opt.laststatus = 3 -- only the last window will always have a status line
vim.opt.showcmd = false -- hide (partial) command in the last line of the screen (for performance)
vim.opt.ruler = false -- hide the line and column number of the cursor position
vim.opt.numberwidth = 4 -- minimal number of columns to use for the line number {default 4}
vim.opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false -- display lines as one long line
vim.opt.scrolloff = 8 -- minimal number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 8 -- minimal number of screen columns to keep to the left and right of the cursor if wrap is `false`
vim.opt.guifont = "monospace:h17" -- the font used in graphical neovim applications
vim.opt.fillchars.eob = " " -- show empty lines at the end of a buffer as ` ` {default `~`}
vim.opt.shortmess:append("c") -- hide all the completion messages, e.g. "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found"
vim.opt.whichwrap:append("<,>,[,],h,l") -- keys allowed to move to the previous/next line when the beginning/end of line is reached
vim.opt.iskeyword:append("-") -- treats words with `-` as single words
vim.opt.relativenumber = true

vim.cmd([[
  nnoremap vv V
  nnoremap V v$
  inoremap , ,<c-g>u
  inoremap . .<c-g>u
  inoremap ! !<c-g>u
  inoremap ? ?<c-g>u
  inoremap ; ;<c-g>u
  inoremap <space> <space><c-g>u
  nnoremap <C-j> <C-w><C-w>
  nnoremap <C-k> <C-w><S-w>
]])

require("darkplus.init").setup()
require("plenary.init")

-- local toggle_tree = function()
--   if vim.o.columns > 120 then
--     vim.g.netrw_winsize = 20
--   else
--     vim.g.netrw_winsize = 30
--   end
-- end

vim.keymap.set("n", "<space>e", "<cmd>lua require('utils.init').toggle_tree()<cr>", { noremap = true, silent = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { noremap = true, silent = true })
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { noremap = true, silent = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { noremap = true, silent = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { noremap = true, silent = true })

function custom()
	require("plenary.popup.init").create("", {
		width = 100,
		height = 50,
    minheight = 30,
    maxheight = 50,
		borderchars = { "─" },
	})
end

local vim_options = {
	width = 1, -- vim.api.nvim_win_get_width(win_id)
	height = 1, -- vim.api.nvim_win_get_height(win_id)
}

vim.api.nvim_create_user_command("CustomRun", "lua custom()", {})
