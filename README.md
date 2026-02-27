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

## 常见错误排查

### `module 'lazy' not found` / `E5113 ... require("lazy")`

**现象**：首次启动 nvim 报错类似：

- `E5113: ... module 'lazy' not found`

**原因**：`lazy.nvim` 需要被克隆到 Neovim 的数据目录（`stdpath("data")/lazy/lazy.nvim`）。新机器上常见情况是：

- `git clone` 中断或网络问题，留下了**不完整/空目录**，导致后续误以为已安装但实际缺文件
- 未安装 `git`
- 数据目录权限异常

**排查与修复**：

1. 确认 `git` 已安装（Debian/Ubuntu）：

```bash
sudo apt install -y git
```

2. 打印你的 Neovim 数据目录（不同机器可能被 `XDG_DATA_HOME` / `NVIM_APPNAME` 影响）：

```bash
nvim --headless +'lua print(vim.fn.stdpath("data"))' +q
```

3. 删除可能残留的 `lazy.nvim` 半成品目录，然后重新启动 nvim 触发自动安装：

```bash
rm -rf ~/.local/share/nvim/lazy/lazy.nvim
nvim
```

如果第 2 步输出的 data 目录不是 `~/.local/share/nvim`，请把上面的路径替换为：

- `<你的data目录>/lazy/lazy.nvim`

## 文档

更多说明见仓库内 `docs/` 目录：

| 文档 | 说明 |
|------|------|
| [docs/shortcut-tips.md](docs/shortcut-tips.md) | 常用快捷键技巧，日常速查（Leader、分屏、窗口等） |
| [docs/keymap-guide.md](docs/keymap-guide.md) | 键位（Keymap）速查与自定义说明 |
| [docs/text-object.md](docs/text-object.md) | 文本对象（Text Objects）扩展选择 |
| [docs/lua-config.md](docs/lua-config.md) | Lua 配置与包管理（模块路径、require 等） |
| [docs/lazy-plugin-spec.md](docs/lazy-plugin-spec.md) | lazy.nvim 插件定义（Plugin Spec）说明 |
