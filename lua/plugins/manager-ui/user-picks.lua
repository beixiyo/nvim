-- ================================
-- 可选插件勾选状态（由 :PluginManager GUI 写入，或手动编辑）
-- ================================
-- 克隆仓库后默认全选；可在此关闭不需要的插件，或通过 :PluginManager 多选后保存
-- 修改后需重启 Neovim 或执行 :Lazy sync 以生效

return {
  ["gitsigns"] = true,
  ["blink"] = true,
  ["supermaven"] = false,
  ["lsp"] = true,
  ["trouble"] = true,
  ["mini-pairs"] = true,
  ["render-markdown"] = true,
  ["treesitter"] = true,
  ["comment"] = false,
  ["flash"] = true,
  ["smear-cursor"] = true,
  ["hover"] = true,
  ["multicursor"] = true,
  ["session"] = true,
  ["which-key"] = true,
  ["yazi"] = true,
  ["bufferline"] = true,
  ["indent"] = true,
  ["lualine"] = true,
  ["noice"] = true,
  ["theme"] = true,
  ["color-picker"] = true,
  ["snacks"] = true,
}
