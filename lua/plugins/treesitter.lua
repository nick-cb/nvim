-- nvim-treesitter `main` branch (Nvim 0.12+): it only installs parsers/queries and
-- provides indentexpr; highlighting and folding are built into Neovim.
local parsers = {
	"css",
	"go",
	"html",
	"javascript",
	"jsdoc",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"scss",
	"tsx",
	"typescript",
	"typst",
	"vimdoc",
	"zig",
}

local no_highlight = { latex = true }
local no_indent = { yaml = true, python = true }

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- does not support lazy-loading
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
				callback = function(args)
					-- snacks.bigfile sets filetype=bigfile, which has no parser
					local lang = vim.treesitter.language.get_lang(args.match)
					if not lang or no_highlight[lang] or not vim.treesitter.language.add(lang) then
						return
					end
					vim.treesitter.start(args.buf, lang)
					if not no_indent[lang] then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		ft = { "html", "javascript", "markdown", "javascriptreact", "typescript", "typescriptreact", "svelte" },
		opts = {},
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		init = function()
			-- no nvim-treesitter module system on the main branch
			vim.g.skip_ts_context_commentstring_module = true
		end,
		opts = {
			enable_autocmd = false,
			languages = {
				typescript = "// %s",
				css = "/* %s */",
				scss = "/* %s */",
				html = "<!-- %s -->",
				svelte = "<!-- %s -->",
				vue = "<!-- %s -->",
				json = "",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("treesitter-context").setup({
				enable = true,
				max_lines = 5,
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "cursor",
				separator = nil,
				zindex = 20,
				on_attach = nil,
			})
		end,
	},
}
