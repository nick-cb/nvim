return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "biome", "prettier" },
				javascriptreact = { "biome" },
				typescript = { "biome" },
				typescriptreact = { "biome" },
				go = { "gofmt" },
				html = { "prettierd", "prettier" },
				css = { "prettierd", "prettier" },
				svelte = { "prettier", "prettierd" },
				zig = { "zigfmt" },
				rust = { "rustfmt" },
				json = { "prettier", "prettierd" },
			},
		},
		keys = {
			{
				"<leader>lf",
				function()
					require("conform").format()
				end,
			},
		},
	},
}
