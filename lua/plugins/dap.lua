function close_all()
	local ok_dap, dap = pcall(require, "dap")
	local ok_dapui, dapui = pcall(require, "dapui")
	if not ok_dap or not ok_dapui then
		return
	end

  local i = 0
  while dap.session() ~= nil do
    i = i + 1
    if i >= 50 then
      break
    end
    dap.terminate()
    dap.close()
  end
  dapui.close()
end

return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        "delve",
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-neotest/nvim-nio",
    },
    config = function ()
      local ok_dap, dap = pcall(require, "dap")
      local ok_dapui, dapui = pcall(require, "dapui")
      if not ok_dap or not ok_dapui then
        return
      end

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
        controls = {
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
          },
        },
      })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      dap.listeners.after["event_initialized"]["me"] = function()
        for _, buf in pairs(vim.api.nvim_list_bufs()) do
          pcall(vim.keymap.del, "n", "K", { buffer = buf })
          vim.keymap.set("n", "K", '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
        end
      end

      dap.listeners.after["event_terminated"]["me"] = function()
        for _, buf in pairs(vim.api.nvim_list_bufs()) do
          pcall(vim.keymap.del, "n", "K")
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buf, desc = "Hover Documentation" })
        end
      end

      dap.listeners.after["event_exited"]["me"] = function()
        vim.print("exit")
        for _, buf in pairs(vim.api.nvim_list_bufs()) do
          pcall(vim.keymap.del, "n", "K")
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buf, desc = "Hover Documentation" })
        end
      end
    end
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "leoluz/nvim-dap-go",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      require("dap-go").setup({
        delve = {
          detached = vim.fn.has("win32") == 0,
        },
      })

      require("dap").adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          -- 💀 Make sure to update this path to point to your installation
          args = { vim.fn.stdpath("data") .. "/lazy/js-debug/src/dapDebugServer.js", "${port}" },
        },
      }

      require("dap-python").setup()
      require("dap.ext.vscode").load_launchjs(nil, { javascript = "js" })

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.api.nvim_create_augroup("DAP_UI_RESET", { clear = true })
    end,
    keys = {
      { "<F5>", function() require("dap").step_into() end },
      { "<F2>", function() require("dap").step_over() end },
      { "<F3>", function() require("dap").step_out() end },
      { "<F9>", function() require("dap").toggle_breakpoint() end },
      { "<f24>", close_all },
      { "<F12>", function () require("dapui").toggle() end },
    },
  },
  {
    "mxsdev/nvim-dap-vscode-js",
  },
}
