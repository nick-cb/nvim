local M = {}

M.setup = function()
	require("nvim-web-devicons").set_icon({
		["README.md"] = {
			icon = "齃",
			color = "#d29922",
			name = "README",
		},
		[".env"] = {
			icon = "",
			color = "#d29922",
			name = "Environment",
		},
		[".env.swo"] = {
			icon = "",
			name = "Environment",
		},
		[".env.swp"] = {
			icon = "",
			name = "Environment",
		},
		[".envrc"] = {
			icon = "",
			name = "Environment",
		},
		["Dockerfile"] = {
			icon = "",
			color = "#34a2f2",
			name = "Dockerfile",
		},
		[".dockerignore"] = {
			icon = "",
			name = "DockerfileIngore",
		},
		["LICENSE"] = {
			icon = "﫥",
			color = "#d29922",
			name = "LICENSE",
		},
		["spec.ts"] = {
			icon = "󰙨",
			color = "#82aaff",
			name = "Test",
		},
		["lock"] = {
			icon = "",
			color = "#ff7b72",
			name = "Lock",
		},
		[".eslintrc"] = {
			icon = "󰱺",
			color = "#713a27",
			name = "Eslint",
		},
		[".eslintignore"] = {
			icon = "",
			name = "EslintIngore",
		},
		[".git"] = {
			icon = "",
			color = "#F34F29",
			name = "Git",
		},
		[".prettierrc"] = {
			icon = "",
			color = "#C695C8",
			name = "Prettier",
		},
		prisma = {
			icon = "",
			color = "#FE69A8",
			name = "Prisma",
		},
		scm = {
			icon = "侮",
			color = "#6A9955",
			name = "Query",
		},
		["Gemfile"] = {
			icon = "",
			color = "#701516",
			name = "Gemfile",
		},
    proto = {
      icon = "󰰘",
      color = "#6089ef",
      name = "Proto"
    },
    xml = {
      icon = "󰗀",
      color = "#bd805c"
    }
	})
end

return M
