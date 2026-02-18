-- ================================
-- Supermaven AI 补全
-- ================================
-- 插件仓库与文档：
-- https://github.com/supermaven-inc/supermaven-nvim
--
-- 说明：
-- - 默认使用内置按键：
--   - <Tab>     接受当前整条补全
--   - <C-]>     清除当前补全
--   - <C-j>     接受下一个单词（按词接受）
-- - 如果你想改键，可以在 opts.keymaps 里覆盖。

return {
  "supermaven-inc/supermaven-nvim",
  event = "InsertEnter", -- 进入插入模式后再加载，避免影响启动速度

  opts = {
    -- 如需自定义按键，可取消注释并调整：
    -- keymaps = {
    --   accept_suggestion = "<Tab>",
    --   clear_suggestion = "<C-]>",
    --   accept_word = "<C-j>",
    -- },

    -- 示例：在某些 filetype 中关闭 Supermaven，可按需增删
    -- ignore_filetypes = {
    --   cpp = true,
    -- },

    -- 建议保留日志，方便排查问题；如果完全不需要可改为 "off"
    log_level = "off",

    -- 如需配合 cmp 等补全插件使用，可以将 inline completion 关闭
    -- disable_inline_completion = false,
    -- disable_keymaps = false,
  },
}

