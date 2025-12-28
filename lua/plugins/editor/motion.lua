return {
	{
		"unblevable/quick-scope",
    init = function ()
      vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }

      vim.cmd([[
      augroup qs_colors
        autocmd!
        autocmd ColorScheme * highlight QuickScopePrimary guifg='#3b8eea' gui=underline ctermfg=155 cterm=underline
        autocmd ColorScheme * highlight QuickScopeSecondary guifg='#f14c4c' gui=underline ctermfg=81 cterm=underline
      augroup END
      ]])
    end
	},
	{
		"mg979/vim-visual-multi",
		branch = "master",
	},
	{
		"gbprod/substitute.nvim",
		config = function()
      require("substitute").setup({})
      vim.keymap.set("n", "s", "<cmd>lua require('substitute').operator({register = 'a'})<cr>", { noremap = true })
      vim.keymap.set("n", "ss", "<cmd>lua require('substitute').line({register = 'a'})<cr>", { noremap = true })
      vim.keymap.set("n", "S", "<cmd>lua require('substitute').eol({register = 'a'})<cr>", { noremap = true })
      vim.keymap.set("x", "s", "<cmd>lua require('substitute').visual({register = 'a'})<cr>", { noremap = true })
      vim.keymap.set("n", "sx", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
      vim.keymap.set("n", "sxx", "<cmd>lua require('substitute.exchange').line()<cr>", { noremap = true })
      vim.keymap.set("x", "X", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })
      vim.keymap.set("n", "sxc", "<cmd>lua require('substitute.exchange').cancel()<cr>", { noremap = true })
		end,
	},
	{
		"tpope/vim-repeat",
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			active = true,
			on_config_done = nil,
			---@usage  modifies the function or method delimiter by filetypes
			map_char = {
				all = "(",
				tex = "{",
			},
			---@usage check bracket in same line
			enable_check_bracket_line = false,
			---@usage check treesitter
			check_ts = true,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
				java = false,
			},
			disable_filetype = { "TelescopePrompt", "spectre_panel" },
			ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
			enable_moveright = true,
			---@usage disable when recording or executing a macro
			disable_in_macro = false,
			---@usage add bracket pairs after quote
			enable_afterquote = true,
			---@usage map the <BS> key
			map_bs = true,
			---@usage map <c-w> to delete a pair if possible
			map_c_w = false,
			---@usage disable when insert after visual block mode
			disable_in_visualblock = false,
			---@usage  change default fast_wrap
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
				offset = 0, -- Offset from pattern match
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "Search",
				highlight_grey = "Comment",
			},
		},
		commit = "0f04d78619cce9a5af4f355968040f7d675854a1",
	},
	{
		"tpope/vim-surround",
		event = "BufRead",
	},
}
