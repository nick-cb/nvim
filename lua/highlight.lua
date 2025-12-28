vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "Normal" })
vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })

local links = {
	["@lsp.type.namespace"] = "@namespace",
	["@lsp.type.type"] = "@type",
	["@lsp.type.class"] = "@type",
	["@lsp.type.enum"] = "@type",
	["@lsp.type.interface"] = "@type",
	["@lsp.type.struct"] = "@structure",
	["@lsp.type.parameter"] = "@parameter",
	["@lsp.type.variable"] = "@variable",
	["@lsp.type.property"] = "@property",
	["@lsp.type.enumMember"] = "@constant",
	["@lsp.type.function"] = "@function",
	["@lsp.type.method"] = "@method",
	["@lsp.type.macro"] = "@macro",
	["@lsp.type.decorator"] = "@function",
	["@tag.builtin.tsx"] = "@keyword",
	-- ['@lsp.typemod.variable.readonly.typescriptreact'] = '@constant.tsx'
	["@tag.tsx"] = "@type.tsx",
	["@keyword.import.tsx"] = "Include",
	["@keyword.export.tsx"] = "Include",
	["@keyword.import.typescript"] = "Include",
	["@keyword.export.typescript"] = "Include",
	["@lsp.typemod.variable.readonly.typescriptreact"] = "Constant",
	["@lsp.typemod.variable.readonly.typescript"] = "Constant",
	["@keyword.exception.typescript"] = "Include",
}
for newgroup, oldgroup in pairs(links) do
	vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
end

vim.cmd([[
  set rtp+=/opt/homebrew/opt/fzf
]])
