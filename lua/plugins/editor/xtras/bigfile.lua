return {
  {
    "LunarVim/bigfile.nvim",
    enabled = false,
    opts = {
      filesize = 0.4,
      pattern = { "*" },
      features = {
        "indent_blankline",
        "illuminate",
        "lsp",
        "matchparen",
        "vimopts",
        "filetype",
      },
    },
  },
}
