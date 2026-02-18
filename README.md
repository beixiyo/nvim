## 安装

### 前置依赖
```bash
sudo apt install -y git fd-find ripgrep
```

**C 编译器**
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

## Version 
基于 LazyVim v15.13.0: https://github.com/LazyVim/LazyVim/releases/tag/v15.13.0
