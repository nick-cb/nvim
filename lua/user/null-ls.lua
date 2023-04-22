local M = {}

M.setup = function()
  local ok, null_ls = pcall(require, "null-ls")
  if not ok then
    return
  end
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.prettierd.with({
        command = "prettierd",
      }),
      null_ls.builtins.formatting.sql_formatter,
    },
  })
end

return M
