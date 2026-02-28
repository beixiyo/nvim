-- 仅用系统剪贴板（最常用）
vim.opt.clipboard = "unnamedplus"

-- 完全不用外部剪贴板（y/p 只影响 Vim 内部）
-- vim.opt.clipboard = ""

-- 选择剪贴板 + 系统剪贴板都同步
-- vim.opt.clipboard = "unnamed,unnamedplus"

-- 在已有设置上追加（例如已有 "unnamed"）
-- vim.opt.clipboard:append("unnamedplus")

-- =======================

-- WSL 特殊处理换行
if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'win32yank-wsl',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 0,
  }
-- SSH 场景：使用 Neovim 0.10+ 内置 OSC52，通过终端（如 wezterm）把远端复制同步到本机剪贴板
elseif vim.env.SSH_TTY and vim.fn.has("nvim-0.10") == 1 then
  local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
  if ok then
    local function osc52_paste()
      return {
        vim.fn.split(vim.fn.getreg(""), "\n"),
        vim.fn.getregtype(""),
      }
    end

    vim.g.clipboard = {
      name = "OSC 52",
      copy = {
        ["+"] = osc52.copy("+"),
        ["*"] = osc52.copy("*"),
      },
      -- wezterm 目前不支持通过 OSC52 读取剪贴板，这里用内部寄存器做粘贴，避免 10s 卡顿
      paste = {
        ["+"] = osc52_paste,
        ["*"] = osc52_paste,
      },
    }
  end
end
