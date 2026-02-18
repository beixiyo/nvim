-- ================================
-- 颜色选择器
-- @link https://github.com/uga-rosa/ccc.nvim
-- ================================
return {
  {
    "uga-rosa/ccc.nvim",
    event = "BufEnter",
    config = function()
      local ccc = require("ccc")
      local icons = require("utils").icons

      ccc.setup({
        highlighter = {
          auto_enable = true, -- 自动高亮
          lsp = true,
        },
      })

      vim.keymap.set("n", "<leader>cp", "<cmd>CccPick<CR>", { desc = icons.kinds.Color .. " 颜色选择器" })
      vim.keymap.set("n", "<leader>ch", "<cmd>CccHighlighterToggle<CR>", { desc = icons.kinds.Color .. " 切换颜色高亮" })
    end,
  },
}
