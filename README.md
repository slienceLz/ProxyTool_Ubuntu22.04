# Proxy Tool for Ubuntu 22.04

[English](README.md) | [中文](README_zh.md)

A simple command-line tool to manage proxy settings on Ubuntu.

## Features
- **Start/Stop**: Easily enable or disable proxy settings.
- **Global Proxy**: Sets system-wide environment variables (`http_proxy`, `https_proxy`, etc.) and GNOME settings.
- **Protocol Support**: Supports HTTP and SOCKS5 proxies.
- **Check Availability**: Built-in connectivity check.
- **Help**: Built-in help command.

## Installation

Since this tool modifies environment variables for your current shell, it must be **sourced** rather than executed directly.

1.  Download the `proxy_tool.sh` script to your preferred location (e.g., `~/scripts/`).
2.  Add the following line to your `~/.bashrc` (or `~/.zshrc` if you use Zsh):

    ```bash
    source ~/scripts/proxy_tool.sh
    ```

3.  Apply the changes immediately:

    ```bash
    source ~/.bashrc
    ```

Now you can use the `proxy` command in your terminal.

## Usage

### 1. Configure Proxy
First, configure your proxy server details (host and port).
Optionally specify the protocol (default is `http`).

```bash
# Syntax: proxy config <host> <port> [protocol]
proxy config 127.0.0.1 7890
# Or for SOCKS5:
proxy config 127.0.0.1 1080 socks5
```

### 2. Enable Proxy
Turn on the proxy settings.

```bash
proxy on
```

### 3. Disable Proxy
Turn off the proxy settings.

```bash
proxy off
```

### 4. Check Status
View current proxy environment variables.

```bash
proxy status
```

### 5. Test Connectivity
Check if the proxy is working by connecting to Google.

```bash
proxy check
```

### 6. Help
View available commands.

```bash
proxy help
```

## How it works
- The `proxy on` command exports standard environment variables (`http_proxy`, `https_proxy`, `ftp_proxy`, `all_proxy`, `no_proxy`).
- It also attempts to set GNOME system proxy settings using `gsettings` if available.
- The configuration is saved in `~/.proxy_config`.
