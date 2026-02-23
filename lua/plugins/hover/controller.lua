-- ================================
-- hover.nvim - Controller 模块
-- ================================
-- 单一职责：处理鼠标事件、定时器、状态管理
-- 不处理内容获取或 UI 渲染

local M = {}

---@type HoverConfig|{}
local config = {}
---@type HoverView|nil
local view = nil
---@type HoverProvider|nil
local provider = nil

-- 内部状态
local enabled = false
local hover_timer = nil
local close_timer = nil
local last_mouse_key = nil
local active_hover_key = nil
local request_token = 0 -- 用于解决竞态条件

-- 鼠标移动事件映射键
local MOUSE_MOVE_KEY = "<MouseMove>"

---初始化 controller 模块
---@param cfg table 配置
---@param v table view 模块
---@param p function provider 函数
function M.setup(cfg, v, p)
  config = cfg
  view = v
  provider = p
end

---启用插件
function M.enable()
  if enabled then
    return
  end
  
  enabled = true
  
  -- 启用鼠标移动事件
  vim.o.mousemoveevent = true
  
  -- 注册鼠标移动事件
  pcall(vim.keymap.set, "n", MOUSE_MOVE_KEY, M._on_mouse_move, {
    desc = "鼠标悬停自动显示 Hover",
  })
  
  -- 注册滚轮事件（用于滚动浮窗）
  pcall(vim.keymap.set, "n", "<ScrollWheelUp>", function()
    M._on_scroll("up")
  end, { desc = "向上滚动 Hover 浮窗" })
  pcall(vim.keymap.set, "n", "<ScrollWheelDown>", function()
    M._on_scroll("down")
  end, { desc = "向下滚动 Hover 浮窗" })
  
  -- 如果配置了插入模式关闭，注册 autocmd
  if config.behavior.close_on_insert then
    vim.api.nvim_create_autocmd("InsertEnter", {
      callback = function()
        M._cleanup_timers()
        if view then
          view.close()
        end
      end,
    })
  end
end

---禁用插件
function M.disable()
  if not enabled then
    return
  end
  
  enabled = false
  
  -- 清理定时器
  M._cleanup_timers()
  
  -- 关闭浮窗
  if view then
    view.close()
  end
  
  -- 移除鼠标移动事件映射
  pcall(vim.keymap.del, "n", MOUSE_MOVE_KEY)
  pcall(vim.keymap.del, "n", "<ScrollWheelUp>")
  pcall(vim.keymap.del, "n", "<ScrollWheelDown>")
  
  -- 重置状态
  last_mouse_key = nil
  active_hover_key = nil
end

---设置自定义 provider
---@param fn function provider 函数
function M.set_provider(fn)
  provider = fn
end

---手动显示 hover（基于当前鼠标位置）
function M.show()
  if not enabled then
    return
  end
  
  local pos = M._get_mouse_pos()
  if not pos then
    return
  end
  
  local key = M._make_mouse_key(pos)
  M._trigger_hover(key)
end

---获取鼠标位置
---@return table|nil
function M._get_mouse_pos()
  local ok, pos = pcall(vim.fn.getmousepos)
  if not ok or not pos or pos.winid == 0 then
    return nil
  end
  return pos
end

---根据鼠标位置构建唯一 key
---@param pos table
---@return string
function M._make_mouse_key(pos)
  return string.format("%d:%d:%d", pos.winid, pos.line, pos.column)
end

---鼠标移动事件处理
function M._on_mouse_move()
  if not enabled then
    return
  end
  
  local pos = M._get_mouse_pos()
  if not pos then
    -- 鼠标离开窗口：清理定时器并关闭 hover
    M._cleanup_timers()
    last_mouse_key = nil
    if view then
      view.close()
    end
    return
  end
  
  local key = M._make_mouse_key(pos)
  
  -- 鼠标进入 hover 浮窗 UI 时，不要关闭/不要重触发
  if view and view.is_open and view.is_open() and view.is_mouse_inside and view.is_mouse_inside(pos) then
    -- 鼠标在浮窗内，取消关闭定时器（如果存在）
    if close_timer then
      close_timer:stop()
      close_timer:close()
      close_timer = nil
    end
    -- 不触发关闭逻辑，直接返回
    return
  end
  
  -- 鼠标从当前 hover 位置移开时
  if active_hover_key and key ~= active_hover_key then
    -- 如果有延迟关闭，则启动定时器
    if config.behavior.close_on_move then
      M._schedule_close()
    end
  end
  
  -- 位置未变化，不需要重置定时器（防抖）
  if last_mouse_key == key then
    return
  end
  
  last_mouse_key = key
  
  -- 启动 hover 定时器
  M._start_hover_timer(key)
end

---滚轮事件处理
---@param direction "up"|"down"
function M._on_scroll(direction)
  if not enabled then
    return
  end

  local pos = M._get_mouse_pos()
  if view and view.is_open() and view.is_mouse_inside(pos) then
    vim.schedule(function()
      view.scroll(direction)
    end)
    return
  end

  local key = direction == "up" and "3<C-Y>" or "3<C-E>"
  local esc_key = vim.api.nvim_replace_termcodes(key, true, false, true)
  vim.api.nvim_feedkeys(esc_key, "n", false)
end

---启动 hover 定时器
---@param key string 鼠标位置 key
function M._start_hover_timer(key)
  -- 清理旧定时器
  if hover_timer then
    hover_timer:stop()
    hover_timer:close()
    hover_timer = nil
  end
  
  -- 创建新定时器
  hover_timer = vim.uv.new_timer()
  hover_timer:start(config.timing.hover_delay, 0, vim.schedule_wrap(function()
    -- 检查鼠标位置是否仍然匹配
    local pos = M._get_mouse_pos()
    if not pos then
      return
    end
    
    local current_key = M._make_mouse_key(pos)
    if current_key == key then
      M._trigger_hover(key)
    end
    
    -- 清理定时器
    if hover_timer then
      hover_timer:close()
      hover_timer = nil
    end
  end))
end

---触发 hover 显示
---@param key string 鼠标位置 key
function M._trigger_hover(key)
  local pos = M._get_mouse_pos()
  if not pos then
    return
  end
  
  local winid = pos.winid
  local bufnr = vim.api.nvim_win_get_buf(winid)
  
  -- buffer 校验
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  
  if config.behavior.only_normal_buf and vim.bo[bufnr].buftype ~= "" then
    return
  end
  
  -- 构建上下文
  local line_text = vim.api.nvim_buf_get_lines(bufnr, pos.line - 1, pos.line, true)[1] or ""
  local ctx = {
    bufnr = bufnr,
    winid = winid,
    row = pos.line,
    col = pos.column,
    line_text = line_text,
    mouse_pos = pos,
    lsp_clients = vim.lsp.get_clients({ bufnr = bufnr }),
  }
  
  -- 生成请求 token（用于解决竞态条件）
  request_token = request_token + 1
  local current_token = request_token
  
  if not provider then
    return
  end
  
  -- 调用 provider 获取内容
  -- provider 可能是：
  -- 1. 自定义函数：function(ctx) -> result | nil（同步）
  -- 2. LSP provider：function(ctx, callback) -> boolean（异步，返回是否成功发起请求）
  
  -- 定义回调函数
  local callback = function(result)
    -- 检查 token 是否仍然有效（解决竞态条件）
    if current_token ~= request_token then
      return
    end
    
    -- 再次检查鼠标位置是否仍然匹配
    local current_pos = M._get_mouse_pos()
    if not current_pos then
      return
    end
    local current_key = M._make_mouse_key(current_pos)
    if current_key ~= key then
      return
    end
    
    M._show_hover_result(result, key, current_token)
  end
  
  -- 尝试作为异步 provider 调用（LSP provider）
  -- 异步 provider 应该返回 true 表示成功发起请求
  local async_result = provider(ctx, callback)
  
  -- 如果返回 true，说明是异步 provider，已发起请求，等待回调
  -- 如果返回 false/nil，可能是同步 provider 或异步 provider 失败，尝试同步调用
  if async_result ~= true then
    -- 尝试作为同步 provider 调用
    local sync_result = provider(ctx)
    if sync_result and sync_result.lines then
      -- 同步 provider 返回了有效结果
      M._show_hover_result(sync_result, key, current_token)
    end
  end
end

---显示 hover 结果
---@param result table|nil hover 结果 { lines = string[], filetype = string }
---@param key string 鼠标位置 key
---@param token number 请求 token
function M._show_hover_result(result, key, token)
  -- 再次检查 token（双重保险）
  if token ~= request_token then
    return
  end
  
  if not result or not result.lines or vim.tbl_isempty(result.lines) then
    return
  end
  
  -- 关闭旧浮窗
  if view then
    view.close()
  end
  
  -- 打开新浮窗
  if not view then
    return
  end
  local bufnr_f, winid_f = view.open(result.lines, result.filetype)
  if bufnr_f and winid_f then
    active_hover_key = key
  end
end

---延迟关闭浮窗
function M._schedule_close()
  -- 清理旧定时器
  if close_timer then
    close_timer:stop()
    close_timer:close()
    close_timer = nil
  end
  
  -- 如果延迟时间为 0，立即关闭
  if config.timing.close_delay == 0 then
    if view then
      view.close()
    end
    active_hover_key = nil
    return
  end
  
  -- 创建延迟关闭定时器
  close_timer = vim.uv.new_timer()
  close_timer:start(config.timing.close_delay, 0, vim.schedule_wrap(function()
    -- 检查鼠标是否已经移回
    local pos = M._get_mouse_pos()
    if pos then
      local key = M._make_mouse_key(pos)
      if key == active_hover_key then
        -- 鼠标移回了，取消关闭
        if close_timer then
          close_timer:close()
          close_timer = nil
        end
        return
      end
    end
    
    if view then
      view.close()
    end
    active_hover_key = nil
    
    if close_timer then
      close_timer:close()
      close_timer = nil
    end
  end))
end

---清理所有定时器
function M._cleanup_timers()
  if hover_timer then
    hover_timer:stop()
    hover_timer:close()
    hover_timer = nil
  end
  
  if close_timer then
    close_timer:stop()
    close_timer:close()
    close_timer = nil
  end
end

return M
