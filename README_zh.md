# Ubuntu 22.04 代理工具

[English](README.md) | [中文](README_zh.md)

一个简单的命令行工具，用于管理 Ubuntu 上的代理设置。

## 功能特性
- **启停便捷**：通过简单的命令开启或关闭代理。
- **全局代理**：设置系统级环境变量（`http_proxy`, `https_proxy` 等）以及 GNOME 桌面设置。
- **协议支持**：支持 HTTP 和 SOCKS5 代理。
- **连通性检查**：内置代理可用性检查功能。
- **帮助信息**：内置帮助命令。

## 安装说明

由于此工具需要修改当前 shell 的环境变量，因此必须通过 **source** 命令加载，而不能直接执行。

1.  下载 `proxy_tool.sh` 脚本到你喜欢的目录（例如 `~/scripts/`）。
2.  将以下行添加到你的 `~/.bashrc`（如果你使用 Zsh，则添加到 `~/.zshrc`）：

    ```bash
    source ~/scripts/proxy_tool.sh
    ```

3.  立即应用更改：

    ```bash
    source ~/.bashrc
    ```

现在你可以在终端中使用 `proxy` 命令了。

## 使用方法

### 1. 配置代理
首先，配置你的代理服务器地址（主机和端口）。
可选指定协议（默认为 `http`）。

```bash
# 语法: proxy config <host> <port> [protocol]
proxy config 127.0.0.1 7890
# 或者配置 SOCKS5:
proxy config 127.0.0.1 1080 socks5
```

### 2. 开启代理
启用代理设置。

```bash
proxy on
```

### 3. 关闭代理
禁用代理设置。

```bash
proxy off
```

### 4. 查看状态
查看当前的代理环境变量。

```bash
proxy status
```

### 5. 测试连接
检查代理是否工作正常（尝试连接 Google）。

```bash
proxy check
```

### 6. 帮助
查看可用命令。

```bash
proxy help
```

## 工作原理
- `proxy on` 命令会导出标准的环境变量 (`http_proxy`, `https_proxy`, `ftp_proxy`, `all_proxy`, `no_proxy`)。
- 如果可用，它还会尝试使用 `gsettings` 设置 GNOME 系统代理。
- 配置信息保存在 `~/.proxy_config` 文件中。
