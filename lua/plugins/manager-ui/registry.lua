-- ================================
-- 可选插件注册表（供插件管理 GUI 与条件加载使用）
-- ================================
-- 别人克隆仓库后可通过 :PluginManager 自选要安装的插件；未勾选的不会 import，Lazy 不会安装。

local M = {}

---@class PluginEntry
---@field id string 唯一 ID，与 user-picks 的 key 对应
---@field desc string 简短描述
---@field category string 分类：code | tools | ui
---@field import string require 路径，如 "plugins.code.gitsigns"

---@type PluginEntry[]
M.optional_plugins = {
  -- code
  { id = "gitsigns",       desc = "Git 行内标记与 hunk 操作",     category = "code", import = "plugins.code.gitsigns" },
  { id = "blink",          desc = "补全与 LSP 增强",              category = "code", import = "plugins.code.blink" },
  { id = "supermaven",     desc = "Supermaven AI 代码补全",       category = "code", import = "plugins.code.supermaven" },
  { id = "lsp",            desc = "LSP 与代码诊断",              category = "code", import = "plugins.code.lsp" },
  { id = "mini-pairs",     desc = "自动括号/引号配对",            category = "code", import = "plugins.code.mini-pairs" },
  { id = "render-markdown", desc = "Markdown 渲染预览",           category = "code", import = "plugins.code.render-markdown" },
  { id = "treesitter",     desc = "语法高亮与语法树",            category = "code", import = "plugins.code.treesitter" },
  { id = "comment",        desc = "智能行/块注释（含 TSX 支持）", category = "code", import = "plugins.code.comment" },

  -- tools
  { id = "flash",          desc = "快速跳转",                    category = "tools", import = "plugins.tools.flash" },
  { id = "multicursor",    desc = "多光标编辑",                  category = "tools", import = "plugins.tools.multicursor" },
  { id = "session",        desc = "会话保存与恢复",              category = "tools", import = "plugins.tools.session" },
  { id = "which-key",      desc = "快捷键提示",                   category = "tools", import = "plugins.tools.which-key" },
  { id = "yazi",           desc = "文件管理器 Yazi 集成",        category = "tools", import = "plugins.tools.yazi" },
  { id = "trouble",        desc = "LSP/诊断列表（按文件分组）",   category = "tools", import = "plugins.tools.trouble" },

  -- ui
  { id = "codediff",       desc = "VSCode 风格双栏 Diff",        category = "ui", import = "plugins.ui.codediff" },
  { id = "diffview",       desc = "Git 双栏 Diff 视图",          category = "ui", import = "plugins.ui.diffview" },
  { id = "hover",          desc = "鼠标悬停自动 Hover（LSP/自定义内容）", category = "ui", import = "plugins.ui.hover" },
  { id = "bufferline",     desc = "标签式 Buffer 栏",            category = "ui", import = "plugins.ui.bufferline" },
  { id = "smear-cursor",   desc = "光标追尾",                    category = "ui", import = "plugins.ui.smear-cursor" },
  { id = "indent",         desc = "缩进参考线",                  category = "ui", import = "plugins.ui.indent" },
  { id = "lualine",        desc = "状态栏",                      category = "ui", import = "plugins.ui.lualine" },
  { id = "noice",          desc = "通知与命令行 UI",             category = "ui", import = "plugins.ui.noice" },
  { id = "theme",          desc = "主题 (TokyoNight 等)",         category = "ui", import = "plugins.ui.theme" },
  { id = "color-picker",   desc = "颜色选择器",                  category = "ui", import = "plugins.ui.color-picker" },
  { id = "snacks",         desc = "核心插件 Snacks",              category = "ui", import = "plugins.snacks" },
}

--- 按分类分组的显示名
M.category_labels = {
  code = "代码",
  tools = "工具",
  ui = "界面",
}

return M
