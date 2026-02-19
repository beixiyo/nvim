-- ================================
-- hover.nvim - 自动 Hover 插件
-- ================================
-- 基于鼠标位置的自动 LSP Hover 显示
-- 兼容 LazyVim，可发布到 GitHub
--
-- 特性：
-- - 鼠标悬停自动显示 LSP 文档
-- - 可自定义内容提供者（支持非 LSP 内容）
-- - 完整的时序配置（延迟、防抖、节流等）
-- - 单一职责的模块化架构

local M = {}

-- 默认配置
local default_config = {
  -- 基础开关
  enabled = true,

  -- 时序配置
  timing = {
    hover_delay = 500,        -- 鼠标停留触发延迟（ms）
    debounce_ms = 50,         -- 鼠标移动防抖时间（ms）
    throttle_ms = 100,        -- 鼠标移动节流时间（ms）
    close_delay = 300,        -- 鼠标移开后延迟关闭时间（ms）
    min_show_time = 0,        -- 最小显示时长（ms）
  },

  -- UI 配置
  ui = {
    border = "rounded",
    max_width = 80,
    max_height = 20,
    focusable = true,
    zindex = 150,
    relative = "mouse",       -- 浮窗相对位置：mouse | cursor | editor
  },

  -- 行为配置
  behavior = {
    close_on_move = true,     -- 鼠标移出符号位置时自动关闭
    close_on_insert = false,  -- 进入插入模式时关闭
    only_normal_buf = true,   -- 只在普通文件 buffer 中启用
  },

  -- 内容提供者：nil 表示使用默认 LSP provider
  -- 函数签名：function(ctx) -> { lines = string[], filetype = string } | nil
  -- ctx 包含：bufnr, winid, row, col, line_text, mouse_pos, lsp_clients
  provider = nil,
}

-- 内部状态
local config = {}
local controller = nil
local view = nil
local provider = nil

---设置插件配置
---@param opts table|nil 配置选项
function M.setup(opts)
  opts = opts or {}

  -- 合并配置
  config = vim.tbl_deep_extend("force", default_config, opts)

  -- 合并嵌套配置
  if opts.timing then
    config.timing = vim.tbl_deep_extend("force", default_config.timing, opts.timing)
  end
  if opts.ui then
    config.ui = vim.tbl_deep_extend("force", default_config.ui, opts.ui)
  end
  if opts.behavior then
    config.behavior = vim.tbl_deep_extend("force", default_config.behavior, opts.behavior)
  end

  -- 初始化模块
  controller = require("plugins.hover.controller")
  view = require("plugins.hover.view")

  -- 设置默认 provider（如果未指定）
  if not config.provider then
    local lsp_provider = require("plugins.hover.providers.lsp")
    provider = lsp_provider.new(config)
  else
    provider = config.provider
  end

  -- 初始化 controller 和 view
  controller.setup(config, view, provider)
  view.setup(config)

  -- 如果启用，自动启动
  if config.enabled then
    M.enable()
  end
end

---启用插件
function M.enable()
  if controller then
    controller.enable()
  end
end

---禁用插件
function M.disable()
  if controller then
    controller.disable()
  end
end

---设置自定义内容提供者
---@param fn function 内容提供者函数
function M.set_provider(fn)
  provider = fn
  if controller then
    controller.set_provider(fn)
  end
end

---手动显示 hover（基于当前鼠标位置）
function M.show()
  if controller then
    controller.show()
  end
end

---手动关闭 hover
function M.hide()
  if view then
    view.close()
  end
end

---获取当前配置
---@return table
function M.get_config()
  return vim.deepcopy(config)
end

return M
