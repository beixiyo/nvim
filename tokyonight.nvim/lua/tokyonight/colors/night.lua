local ret = vim.deepcopy(require("tokyonight.colors.storm"))

---@type Palette
return vim.tbl_deep_extend("force", ret, {
  bg = "#191816",
  bg_dark = "#181818",
  bg_dark1 = "#181818",
})
