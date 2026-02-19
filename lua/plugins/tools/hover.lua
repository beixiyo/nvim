-- Hover：鼠标悬停自动显示 LSP Hover（支持自定义 provider）
-- 本插件实现位于本仓库的 lua/plugins/hover/（作为本地插件 dir 引入）

---@type LazySpec[]
return {
  {
    name = "hover.nvim",
    dir = vim.fn.stdpath("config") .. "/lua/plugins/hover",
    lazy = false,
    cond = function()
      return not vim.g.vscode
    end,
    ---@type HoverConfig
    opts = {
      enabled = true,
      timing = {
        hover_delay = 500,
        debounce_ms = 50,
        throttle_ms = 100,
        close_delay = 0,
        min_show_time = 0,
      },
      ui = {
        border = "rounded",
        max_width = 80,
        max_height = 20,
        focusable = false,
        zindex = 150,
        relative = "mouse",
      },
      behavior = {
        close_on_move = true,
        close_on_insert = false,
        only_normal_buf = true,
      },
    },
    config = function(_, opts)
      require("plugins.hover").setup(opts)
    end,
  },
}

