---
-- 滚动条（支持鼠标拖拽）
-- @link https://github.com/dstein64/nvim-scrollview
---
return {
  "dstein64/nvim-scrollview",
  event = "BufReadPost",
  config = function()
    require("scrollview").setup({
      excluded_filetypes = {
        "terminal",
        "toggleterm",
        "blink-cmp-menu",
        "cmp_docs",
        "cmp_menu",
        "dropbar_menu",
        "dropbar_menu_fzf",
        "DressingInput",
        "noice",
        "prompt",
        "TelescopePrompt",
      },
      signs_on_startup = { "diagnostics", "search", "marks", "cursor" },
    })

    -- 使用当前主题（TokyoNight）色板设置滚动条高亮
    local style = (vim.g.colors_name or ""):match("^tokyonight%-(.+)$") or "night"
    local ok, colors = pcall(require("tokyonight.colors").setup, require("tokyonight.config").extend({ style = style }))
    if not ok or not colors then
      return
    end

    local function hl(name, opts)
      vim.api.nvim_set_hl(0, name, opts)
    end

    -- 滚动条轨道/滑块
    hl("ScrollView", { bg = colors.bg_highlight, fg = colors.none })
    -- 悬停高亮
    hl("ScrollViewHover", { bg = colors.bg_visual, fg = colors.none })
    -- 受限模式（大文件时）
    hl("ScrollViewRestricted", { bg = colors.bg_highlight, fg = colors.fg_gutter })
    -- 诊断
    hl("ScrollViewDiagnosticsError", { fg = colors.error, bg = colors.none })
    hl("ScrollViewDiagnosticsWarn", { fg = colors.warning, bg = colors.none })
    hl("ScrollViewDiagnosticsInfo", { fg = colors.info, bg = colors.none })
    hl("ScrollViewDiagnosticsHint", { fg = colors.hint, bg = colors.none })
    -- 搜索、光标、标记
    hl("ScrollViewSearch", { fg = colors.orange, bg = colors.none })
    hl("ScrollViewCursor", { fg = colors.blue, bg = colors.none })
    hl("ScrollViewMarks", { fg = colors.purple, bg = colors.none })
  end,
}
