local Icons = require("utils").icons
local icons = Icons
local diag_icons = {
  Error = Icons.diagnostics_error,
  Warn = Icons.diagnostics_warn,
  Hint = Icons.diagnostics_hint,
  Info = Icons.diagnostics_info,
}

return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
    "saghen/blink.cmp",
  },

  opts = {
    ensure_installed = {},
    -- 自动启用已安装的 LSP 服务器（mason-lspconfig 会自动调用 lspconfig.setup）
    automatic_enable = { exclude = {} },
  },
  config = function(_, opts)
    require("mason-lspconfig").setup(opts)

    -- ================================
    -- Diagnostics UI（inline 虚拟文本 + sign 图标）
    -- ================================
    do
      local s = vim.diagnostic.severity
      -- 使用 vim.diagnostic.config 的 signs 配置（替代已弃用的 sign_define）
      vim.diagnostic.config({
        virtual_text = {
          spacing = 2,
          source = "if_many",
          prefix = function(diagnostic)
            if diagnostic.severity == s.ERROR then
              return diag_icons.Error
            elseif diagnostic.severity == s.WARN then
              return diag_icons.Warn
            elseif diagnostic.severity == s.HINT then
              return diag_icons.Hint
            else
              return diag_icons.Info
            end
          end,
        },
        signs = {
          text = {
            [s.ERROR] = diag_icons.Error,
            [s.WARN] = diag_icons.Warn,
            [s.HINT] = diag_icons.Hint,
            [s.INFO] = diag_icons.Info,
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "if_many",
        },
      })
    end

    -- ================================
    -- LSP 快捷键配置（与 which-key 联动）
    -- ================================
    -- 在 LSP attach 时注册快捷键，确保只在有 LSP 客户端时生效
    -- 使用 vim.keymap.set 并添加 desc 参数，which-key 会自动识别并显示
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(event)
        local map = vim.keymap.set
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- 跳转相关（g 前缀，属于 "goto" 组）
        -- 使用 Trouble 作为主视图（按文件分组 / 树形）
        map("n", "gd", "<cmd>Trouble lsp_definitions toggle focus=true win.position=left<cr>", { desc = icons.jumps .. " " .. "定义", buffer = event.buf })
        map("n", "gD", "<cmd>Trouble lsp_declarations toggle focus=true win.position=left<cr>", { desc = icons.jumps .. " " .. "声明", buffer = event.buf })
        map("n", "gr", "<cmd>Trouble lsp_references toggle focus=true win.position=left<cr>", { desc = icons.jumps .. " " .. "引用（按文件分组）", buffer = event.buf, nowait = true })
        map("n", "gI", "<cmd>Trouble lsp_implementations toggle focus=true win.position=left<cr>", { desc = icons.jumps .. " " .. "实现", buffer = event.buf })
        map("n", "gy", "<cmd>Trouble lsp_type_definitions toggle focus=true win.position=left<cr>", { desc = icons.jumps .. " " .. "类型定义", buffer = event.buf })

        -- 悬停和签名帮助
        map("n", "K", vim.lsp.buf.hover, { desc = icons.vscode .. " " .. "显示悬停信息", buffer = event.buf })
        map("n", "gK", vim.lsp.buf.signature_help, { desc = icons.vscode .. " " .. "显示签名帮助", buffer = event.buf })
        map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = icons.vscode .. " " .. "显示签名帮助", buffer = event.buf })

        -- Code 组快捷键（<leader>c 前缀，属于 "code" 组）
        if client and client.supports_method("textDocument/codeAction") then
          map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = icons.fix .. " " .. "自动修复", buffer = event.buf })
        end

        if client and client.supports_method("textDocument/rename") then
          map("n", "<leader>cr", vim.lsp.buf.rename, { desc = icons.rename .. " " .. "重命名", buffer = event.buf })
        end

        if client and (client.supports_method("textDocument/formatting") or client.supports_method("textDocument/rangeFormatting")) then
          map("n", "<leader>cf", function()
            vim.lsp.buf.format({ async = true })
          end, { desc = icons.lsp .. " " .. "格式化", buffer = event.buf })

          map("x", "<leader>cf", function()
            vim.lsp.buf.format({ async = true, range = { ["start"] = vim.api.nvim_buf_get_mark(0, "<"), ["end"] = vim.api.nvim_buf_get_mark(0, ">") } })
          end, { desc = icons.lsp .. " " .. "格式化选中区域", buffer = event.buf })
        end

        -- 诊断 & Quickfix / Location（<leader>x 前缀，属于 "diagnostics/quickfix" 组）
        -- 跳转上/下一个诊断（保留原始行为）
        map("n", "[d", vim.diagnostic.goto_prev, { desc = icons.tools .. " " .. "上一个诊断", buffer = event.buf })
        map("n", "]d", vim.diagnostic.goto_next, { desc = icons.tools .. " " .. "下一个诊断", buffer = event.buf })

        -- 当前光标处诊断浮窗
        map("n", "<leader>xd", vim.diagnostic.open_float, { desc = icons.tools .. " " .. "显示诊断信息", buffer = event.buf })

        -- Trouble 诊断 / Quickfix / Loclist / LSP 视图
        map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle focus=true win.position=bottom<cr>", { desc = icons.list .. " " .. "全局诊断列表", buffer = event.buf })
        map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle focus=true filter.buf=0 win.position=bottom<cr>", { desc = icons.list .. " " .. "当前诊断列表", buffer = event.buf })
        map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = icons.list .. " " .. "Quickfix 列表", buffer = event.buf })
        map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = icons.list .. " " .. "Location 列表", buffer = event.buf })

        -- LSP 符号 / 调用关系（Trouble 视图）
        map("n", "<leader>ls", "<cmd>Trouble symbols toggle focus=true win.position=right<cr>", { desc = icons.vscode .. " " .. "文档符号", buffer = event.buf })
        map("n", "<leader>lS", "<cmd>Trouble lsp_document_symbols toggle focus=true win.position=right<cr>", { desc = icons.vscode .. " " .. "文档符号原始视图", buffer = event.buf })
        map("n", "<leader>lci", "<cmd>Trouble lsp_incoming_calls toggle focus=true win.position=right<cr>", { desc = icons.vscode .. " " .. "传入调用", buffer = event.buf })
        map("n", "<leader>lco", "<cmd>Trouble lsp_outgoing_calls toggle focus=true win.position=right<cr>", { desc = icons.vscode .. " " .. "传出调用", buffer = event.buf })
      end,
    })
  end,
}
