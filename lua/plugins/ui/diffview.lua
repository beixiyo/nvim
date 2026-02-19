-- ================================
-- Git 双栏 diff 对比 https://github.com/sindrets/diffview.nvim
-- ================================
-- 功能：
-- - VSCode 风格的双栏 diff 视图，有点臃肿且不好退出，推荐 codediff.nvim
-- - 支持任意 revision 对比（HEAD、commits、branches、tags）
-- - merge conflict 处理
-- - 文件树导航
--
-- 命令：
-- - :DiffviewOpen [git-rev] [options]  打开 diff 视图
-- - :DiffviewClose                     关闭 diff 视图
-- - :DiffviewToggleFiles               切换文件树面板
-- - :DiffviewFileHistory [paths]       查看文件历史

local icons = require("utils").icons

return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
  keys = {
    {
      "<leader>gD",
      function()
        vim.cmd("DiffviewOpen")
      end,
      desc = icons.git_diff .. " 打开 Git Diff 视图",
    },
    {
      "<leader>ghf",
      function()
        vim.cmd("DiffviewFileHistory %")
      end,
      desc = icons.git_log .. " 查看当前文件历史",
    },
    {
      "<leader>ghF",
      function()
        vim.cmd("DiffviewFileHistory")
      end,
      desc = icons.git_log .. " 查看项目文件历史",
    },
  },
}
