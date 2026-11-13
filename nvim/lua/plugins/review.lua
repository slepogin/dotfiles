return {
  -- Extras you should have enabled in lazy.lua:
  -- { import = "lazyvim.plugins.extras.lang.go" },
  -- { import = "lazyvim.plugins.extras.dap.core" },
  -- { import = "lazyvim.plugins.extras.test.core" },

  ----------------------------------------------------------------
  -- Diff review
  ----------------------------------------------------------------
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff worktree" },
      { "<leader>gm", "<cmd>DiffviewOpen main...HEAD<cr>", desc = "Review vs main" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    },
    opts = { enhanced_diff_hl = true },
  },

  ----------------------------------------------------------------
  -- Symbol outline (right sidebar during reading)
  ----------------------------------------------------------------
  {
    "stevearc/aerial.nvim",
    keys = { { "<leader>cs", "<cmd>AerialToggle right<cr>", desc = "Outline" } },
    opts = {
      layout = { default_direction = "right", min_width = 32 },
      show_guides = true,
      -- only structural stuff, no noise:
      filter_kind = { "Function", "Method", "Struct", "Interface", "Constant" },
    },
  },

  ----------------------------------------------------------------
  -- U-debt keywords + quick-insert mappings
  ----------------------------------------------------------------
  {
    "folke/todo-comments.nvim",
    opts = {
      keywords = {
        UNCLEAR = { icon = "󰘥 ", color = "warning" },
        ASSUME = { icon = " ", color = "hint" },
        OWNED = { icon = " ", color = "test" },
      },
    },
  },
  {
    "nvim-lua/plenary.nvim",
    keys = {
      {
        "<leader>cu",
        function()
          local line = vim.api.nvim_get_current_line()
          local indent = line:match("^%s*") or ""
          vim.api.nvim_put({ indent .. "// UNCLEAR: " }, "l", false, false)
          vim.cmd("normal! j$")
          vim.cmd("startinsert!")
        end,
        desc = "Insert UNCLEAR above line",
      },
      {
        "<leader>cA",
        function()
          local indent = vim.api.nvim_get_current_line():match("^%s*") or ""
          vim.api.nvim_put({ indent .. "// ASSUME: " }, "l", false, false)
          vim.cmd("normal! j$")
          vim.cmd("startinsert!")
        end,
        desc = "Insert ASSUME above line",
      },
    },
  },

  ----------------------------------------------------------------
  -- gopls: max suspicion mode
  ----------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              staticcheck = true,
              analyses = { shadow = true, nilness = true, unusedwrite = true, unusedparams = true },
              codelenses = { test = true, tidy = true },
              hints = { parameterNames = true, constantValues = true }, -- inlay hints while reading
            },
          },
        },
      },
    },
  },

  ----------------------------------------------------------------
  -- DAP: layout + the breadcrumb trail
  ----------------------------------------------------------------
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      layouts = {
        { -- left: what am I looking at
          elements = {
            { id = "stacks", size = 0.45 }, -- the jumpable call chain — biggest
            { id = "scopes", size = 0.40 },
            { id = "breakpoints", size = 0.15 },
          },
          size = 42,
          position = "left",
        },
        { -- bottom: program output only
          elements = { { id = "repl", size = 1.0 } },
          size = 8,
          position = "bottom",
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap, trail = require("dap"), {}
      _G.__dap_trail = trail
      dap.listeners.after.event_stopped["trail"] = function()
        local s = dap.session()
        local f = s and s.current_frame
        if not (f and f.source and f.source.path) then
          return
        end
        local last = trail[#trail]
        if last and last.filename == f.source.path and last.lnum == f.line then
          return
        end
        trail[#trail + 1] = { filename = f.source.path, lnum = f.line, col = (f.column or 0) + 1, text = f.name }
      end
    end,
    keys = {
      {
        "<leader>dT",
        function()
          vim.fn.setqflist({}, " ", { title = "Debug trail", items = _G.__dap_trail })
          vim.cmd("Trouble qflist toggle")
        end,
        desc = "Debug trail",
      },
      {
        "<leader>dX",
        function()
          _G.__dap_trail = {}
        end,
        desc = "Clear trail",
      },
    },
  },

  ----------------------------------------------------------------
  -- QoL for reading sessions
  ----------------------------------------------------------------
  { "folke/snacks.nvim", opts = { scratch = { enabled = true } } }, -- <leader>. scratch note
}
