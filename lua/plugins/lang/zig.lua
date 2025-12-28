return {
	{
		"ziglang/zig.vim",
		config = function()
			vim.cmd([[let g:zig_fmt_autosave = 0]])
		end,
	},
}
