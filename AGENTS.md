# Neovim 配置项目

## 项目概述

这是一个基于 **Lazy.nvim** 插件管理器的 Neovim 配置，采用模块化设计，支持可选插件的 GUI 管理。基于 LazyVim v15.13.0 架构理念，但实现了完全自定义的插件管理系统

### 核心特性

- **可选插件管理**：通过 `:PluginManager` GUI 界面勾选/取消插件，无需手动编辑配置
- **VSCode 集成**：自动检测 `vscode-neovim` 环境，仅加载最小插件集
- **模块化架构**：插件按功能分类（code / tools / ui），便于维护

### 技术栈

| 组件 | 说明 |
|------|------|
| 插件管理器 | lazy.nvim |
| 核心框架 | snacks.nvim（dashboard / picker / terminal / explorer） |
| 补全引擎 | blink.cmp |
| LSP | nvim-lspconfig + mason.nvim |
| 语法高亮 | nvim-treesitter |
| 主题 | tokyonight.nvim + 自定义 pretty_dark |

---

## 目录结构

```
/root/.config/nvim/
├── init.lua                    # 入口文件，加载各模块
├── lazy-lock.json              # 插件版本锁定文件
├── .luarc.json                 # Lua LSP 配置（含插件类型定义）
│
├── lua/
│   ├── utils.lua               # 工具函数、图标定义
│   ├── config/
│   │   ├── options.lua         # 编辑器选项（leader、缩进、编码等）
│   │   ├── keymaps.lua         # 基础快捷键映射
│   │   ├── lazy.lua            # lazy.nvim 引导与配置
│   │   ├── autocmd.lua         # 自动命令
│   │   └── clipboard.lua       # 剪贴板配置
│   │
│   └── plugins/
│       ├── init.lua            # 插件列表入口（条件加载逻辑）
│       ├── snacks.lua          # 核心插件配置
│       ├── manager-ui/
│       │   ├── init.lua        # 插件管理 GUI 实现
│       │   ├── registry.lua    # 可选插件注册表
│       │   └── user-picks.lua  # 用户勾选状态（自动生成）
│       ├── code/               # 代码相关插件
│       ├── tools/              # 工具类插件
│       └── ui/                 # UI 相关插件
│
├── docs/                       # 文档
└── scripts/                    # 脚本工具
```

---

## 可选插件系统

### 架构说明

1. **registry.lua**：定义所有可选插件的元信息（id / desc / category / import）
2. **user-picks.lua**：存储用户勾选状态，由 GUI 自动写入
3. **init.lua**：根据 user-picks 决定加载哪些插件

### 添加新插件

1. 在 `lua/plugins/` 下创建插件配置文件
2. 在 `registry.lua` 的 `M.optional_plugins` 中注册：

```lua
{ id = "my-plugin", desc = "插件描述", category = "tools", import = "plugins.tools.my-plugin" }
```

3. 重启 Neovim 或执行 `:Lazy sync`

### 插件分类

| 分类 | 说明 |
|------|------|
| `code` | 代码相关：LSP、补全、Treesitter、Git、注释等 |
| `tools` | 工具类：跳转、多光标、会话、文件管理器等 |
| `ui` | 界面：状态栏、主题、通知、缩进线等 |

---

## 代码风格

- **缩进**：2 空格
- **注释**：中文注释，文件头部说明模块用途
- **键位**：使用 `utils.icons` 统一图标，`desc` 必须填写
- **类型**：`.luarc.json` 中定义了插件类型引用，支持 LSP 类型提示

### 键位映射规范

```lua
vim.keymap.set("n", "<leader>xx", function()
  -- 函数形式，复杂逻辑
end, { desc = icons.icon .. " " .. "描述文字" })

-- 或字符串形式
vim.keymap.set("n", "<leader>xx", "<cmd>Command<cr>", { desc = "描述" })
```

---

## VSCode 环境

当检测到 `vim.g.vscode` 为 true 时（vscode-neovim 插件），仅加载：

- `flash.nvim`（快速跳转）
- `nvim-treesitter`（语法高亮）

其他插件不加载，保持与 VSCode 原生功能的兼容
