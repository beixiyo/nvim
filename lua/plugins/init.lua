-- 插件列表入口
-- ================================
-- 按文件名排序引入；Snacks 的实际加载顺序由 lazy.nvim 配置控制。
-- 可选插件由 plugins/user-picks.lua 控制，可通过 :PluginManager 勾选。

local registry = require("plugins.manager-ui.registry")
local picks = require("plugins.manager-ui.user-picks")

local function get_plugin_by_id(id)
  for _, entry in ipairs(registry.optional_plugins) do
    if entry.id == id then
      return entry
    end
  end
  return nil
end

-- VSCode（vscode-neovim）中尽量保持最小化：只启用 flash
-- 说明：此处返回的 spec 会直接交给 lazy.nvim；未 import 的插件不会被安装/加载。
if vim.g.vscode then
  return {
    { import = get_plugin_by_id("flash").import },
  }
end

local spec = {
  -- 核心：Snacks（dashboard / picker / terminal / explorer / notifier / bufdelete）
  { import = get_plugin_by_id("snacks").import },
}

for _, entry in ipairs(registry.optional_plugins) do
  if picks[entry.id] ~= false then
    spec[#spec + 1] = { import = entry.import }
  end
end

return spec
