require("options")
require("keymaps")
-- Setup lazy.nvim with modular plugin specs
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)
require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "plugins.ui" },
		{ import = "plugins.completion" },
    { import = "plugins.lang" },
		{ import = "plugins.editor.find" },
		{ import = "plugins.editor.comment" },
		{ import = "plugins.editor.motion" },
		{ import = "plugins.editor.xtras.plenary" },
		{ import = "plugins.editor.xtras.auto-session" },
		{ import = "plugins.editor.xtras.colorizer" },
		{ import = "plugins.editor.xtras.illuminate" },
		{ import = "plugins.editor.xtras.indent-blankline" },
		{ import = "plugins.editor.xtras.mini-icons" },
		{ import = "plugins.editor.xtras.neoscroll" },
		{ import = "plugins.editor.xtras.pencil" },
		{ import = "plugins.editor.xtras.rainbow-delimiters" },
		{ import = "plugins.editor.xtras.colorful-menu" },
	},
})

require("autocmds")
require("highlight")

-- require("luasnip.loaders.from_vscode").lazy_load({
--   paths = {
--     "/Users/nick/.local/share/nvim/lazy/vscode-es7-javascript-react-snippets/",
--   },
-- })
