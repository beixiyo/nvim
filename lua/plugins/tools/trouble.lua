-- 诊断 / LSP 引用列表（按文件分组，类似 VSCode）
-- 文档：https://github.com/folke/trouble.nvim

local icons = require("utils").icons

return {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  -- 确保 :Trouble 命令存在（用于所有 Trouble ... 映射）
  cmd = "Trouble",

  ---@type trouble.Config
  opts = {
    -- 这里只针对我们关心的几个模式做定制，其余沿用默认配置
    modes = {
      -- 全局诊断列表
      diagnostics = {
        win = {
          position = "bottom",
          size = 10,
        },
      },
      -- 当前缓冲区诊断列表
      diagnostics_buffer = {
        win = {
          position = "bottom",
          size = 10,
        },
      },
      -- LSP 引用视图：类似 VSCode「按文件分组的引用列表」
      lsp_references = {
        win = {
          position = "left", -- 左侧栏
          size = 38,        -- 接近典型侧边栏宽度
        },
      },
    },
  },
}
