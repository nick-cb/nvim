return {
	{
		"dsznajder/vscode-es7-javascript-react-snippets",
		build = { "pnpm install && pnpm compile" },
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	},
	{
		"jose-elias-alvarez/typescript.nvim",
		config = function()
			require("typescript").setup({})
		end,
		branch = "no-lspconfig",
		ft = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
	},
}
