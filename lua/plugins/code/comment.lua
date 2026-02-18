-- 智能注释插件：Comment.nvim + ts-context-commentstring
-- 说明：
-- 1. Comment.nvim 提供 gcc/gc 等快捷注释操作
-- 2. ts-context-commentstring 让 JSX/TSX/嵌套语言块使用正确的注释符号

return {
  {
    "nvim-mini/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
}
