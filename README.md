## 安装

### 前置依赖

**字体**：需使用 [Nerd Font](https://www.nerdfonts.com/) 以正确显示配置中的图标。推荐 [Maple Font](https://github.com/subframe7536/maple-font)（含 Nerd Font 补丁）

```bash
# 安装查找工具 fd-find 和 ripgrep
sudo apt install -y git fd-find ripgrep
```

**C 编译器（TreeSitter 依赖）**
  - [Windows w64devkit](https://github.com/skeeto/w64devkit/releases)
  - Linux Debian `sudo apt install build-essential -y`

### 克隆配置
```bash
# Linux
mkdir -p ~/.config/nvim && \
git clone --depth=1 --single-branch --no-tags https://github.com/beixiyo/nvim.git ~/.config/nvim
## 可选删除多余文件
rm -rf ~/.config/nvim/.git

# Window
git clone --depth=1 --single-branch --no-tags https://github.com/beixiyo/nvim.git "$env:LOCALAPPDATA\nvim"

# 启动并自动配置
nvim
```

## 开启插件

1. 进入首页
2. 按下 **p** 触发插件选择，Enter 选择插件
3. q 退出后重新打开触发安装插件

## LSP 安装

输入 `:Mason` 进入 LSP 选中页面，选中后按下 i 安装，也可以按下 Ctrl-f 筛选先语言

比如 ts 可以安装 tsgo

---

## 文档

更多说明见仓库内 `docs/` 目录：

| 文档 | 说明 |
|------|------|
| [docs/shortcut-tips.md](docs/shortcut-tips.md) | 常用快捷键技巧，日常速查（Leader、分屏、窗口等） |
| [docs/keymap-guide.md](docs/keymap-guide.md) | 键位（Keymap）速查与自定义说明 |
| [docs/text-object.md](docs/text-object.md) | 文本对象（Text Objects）扩展选择 |
| [docs/lua-config.md](docs/lua-config.md) | Lua 配置与包管理（模块路径、require 等） |
| [docs/lazy-plugin-spec.md](docs/lazy-plugin-spec.md) | lazy.nvim 插件定义（Plugin Spec）说明 |
