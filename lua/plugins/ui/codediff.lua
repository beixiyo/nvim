-- ================================
-- VSCode 风格双栏 diff https://github.com/esmuellert/codediff.nvim
-- ================================
-- 功能：
-- - VSCode 同款 diff 算法，两级高亮（行级 + 字符级）
-- - 支持 Git 仓库 diff、任意 revision 对比（HEAD / 分支 / commit / tag）
-- - 文件/目录对比、文件历史（history）、merge tool / diff tool 集成
--
-- 常用命令（本配置只用到部分）：
-- - :CodeDiff                     打开 Git 变更总览（Explorer 模式，类似 git status）
-- - :CodeDiff main...             PR 风格 diff：仅显示当前分支相对 main 的改动
-- - :CodeDiff file                当前文件 vs 工作区/指定 revision
-- - :CodeDiff history             当前文件历史（带文件列表和 diff 预览）
--
-- NOTE: 需要海外环境下载依赖
-- 依赖：
-- - MunifTanjim/nui.nvim（UI 组件）
-- - libvscode_diff.{so/dylib/dll}（需从 releases 下载或本地 build）

local icons = require("utils").icons

return {
  "esmuellert/codediff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = "CodeDiff",
  keys = {
    {
      -- 与 snacks.lua 中约定保持一致：<leader>gD = Diff
      "<leader>gD",
      function()
        vim.cmd("CodeDiff")
      end,
      desc = icons.git_diff .. " Git 变更总览（CodeDiff）",
    },
    {
      "<leader>ghf",
      function()
        vim.cmd("CodeDiff history")
      end,
      desc = icons.git_log .. " 当前文件历史（CodeDiff）",
    },
  },
  opts = {
    -- 只保留少量高亮配置，其余使用默认
    highlights = {
      line_insert = "DiffAdd",
      line_delete = "DiffDelete",
      -- 让插件自动根据配色方案推导字符级高亮亮度
      char_brightness = nil,
    },
  },
}
