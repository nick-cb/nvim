return {
	{
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({})
		end,
		commit = "3eb26b949e1b90798e84926848551046e2eb0721",
		cmd = { "SessionSave", "SessionRestore", "SessionRestoreFromFile" },
		lazy = true,
	},
}
