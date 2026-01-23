return {
  {
    "ojroques/nvim-osc52",
    keys = {
      { "<leader>c", function () require('osc52').copy_operator() end },
      { "<leader>cc", "<leader>c_", remap = true },
      { "<leader>c", function () require('osc52').copy_visual() end, mode = "v" },
    }
  },
}
