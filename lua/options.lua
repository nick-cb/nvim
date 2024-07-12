local custom_options = function()
	local custom_options = {
		syntax = "enable",
		relativenumber = true,
		smartcase = true,
		fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]],
		foldcolumn = "1",
		foldlevel = 99,
		foldlevelstart = 99,
		foldminlines = 2,
		foldenable = true,
		-- foldopen = "block,mark,percent,quickfix,search,tag,undo",
		mousemodel = "extend",
		cmdheight = 1,
		timeout = true,
		timeoutlen = 1000,
		backup = false, -- creates a backup file
		clipboard = "unnamedplus", -- allows neovim to access the system clipboard
		completeopt = { "menuone", "noselect" },
		conceallevel = 0, -- so that `` is visible in markdown files
		fileencoding = "utf-8", -- the encoding written to a file
		foldmethod = "expr",                     -- folding, set to "expr" for treesitter based folding
		foldexpr = "nvim_treesitter#foldexpr()", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
		guifont = "JetBrainsMono Nerd Font Mono", -- the font used in graphical neovim applications
		hidden = true, -- required to keep multiple buffers and open multiple buffers
		hlsearch = true, -- highlight all matches on previous search pattern
		ignorecase = true, -- ignore case in search patterns
		mouse = "a", -- allow the mouse to be used in neovim
		pumheight = 10, -- pop up menu height
		showmode = false, -- we don't need to see things like -- INSERT -- anymore
		splitbelow = true, -- force all horizontal splits to go below current window
		splitright = true, -- force all vertical splits to go to the right of current window
		swapfile = false, -- creates a swapfile
		termguicolors = true, -- set term gui colors (most terminals support this)
		title = true, -- set the title of window to the value of the titlestring
		-- opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to
		undofile = true, -- enable persistent undo
		updatetime = 100, -- faster completion
		writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
		expandtab = true, -- convert tabs to spaces
		shiftwidth = 2, -- the number of spaces inserted for each indentation
		tabstop = 2, -- insert 2 spaces for a tab
		cursorline = true, -- highlight the current line
		number = true, -- set numbered lines
		numberwidth = 4, -- set number column width to 2 {default 4}
		signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
		wrap = false, -- display lines as one long line
		scrolloff = 8, -- minimal number of screen lines to keep above and below the cursor.
		sidescrolloff = 8, -- minimal number of screen lines to keep left and right of the cursor.
		showcmd = false,
		ruler = false,
		laststatus = 3,
		linespace = 4,
		-- title = false
	}
	for k, v in pairs(custom_options) do
		vim.opt[k] = v
	end

	if vim.g.neovide then
		-- vim.g.neovide_window_blurred = true
		-- vim.g.neovide_transparency = 0.9
		-- vim.g.neovide_floating_blur_amount_x = 4.0
		-- vim.g.neovide_floating_blur_amount_y = 4.0
		vim.g.neovide_scroll_animation_length = 0.1
	end
end

custom_options()
