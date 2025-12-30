return {
	{
		"dsznajder/vscode-es7-javascript-react-snippets",
		build = { "pnpm install && pnpm compile" },
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	},
	{
		"jose-elias-alvarez/typescript.nvim",
		enabled = false,
		config = function()
			require("typescript").setup({})
		end,
		init = function()
			vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
				pattern = { "*.tsx", "*.ts", "*.js", "*.jsx" },
				callback = function()
					vim.api.nvim_create_user_command(
						"TypescriptAddMissingImports",
						"lua require('typescript').actions.addMissingImports()",
						{}
					)
					vim.api.nvim_create_user_command(
						"TypescriptOrganizeImports",
						"lua require('typescript').actions.organizeImports()",
						{}
					)
					vim.api.nvim_create_user_command(
						"TypescriptRemoveUnused",
						"lua require('typescript').actions.removeUnused()",
						{}
					)
					vim.api.nvim_create_user_command(
						"TypescriptFixAll",
						"lua require('typescript').actions.fixAll()",
						{}
					)
				end,
			})
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
