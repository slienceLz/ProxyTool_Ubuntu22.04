#!/bin/bash

# Proxy Tool for Ubuntu 22.04
# Usage: source this script in your .bashrc or .zshrc
# Example: echo "source /path/to/proxy_tool.sh" >> ~/.bashrc

PROXY_CONFIG_FILE="$HOME/.proxy_config"

function proxy_help() {
    echo "Usage: proxy {on|off|status|check|config|help}"
    echo ""
    echo "Commands:"
    echo "  on      Enable proxy settings (global)"
    echo "  off     Disable proxy settings"
    echo "  status  Show current proxy status"
    echo "  check   Check if proxy is working (curl google.com)"
    echo "  config  Configure proxy server"
    echo "  help    Show this help message"
    echo ""
    echo "Examples:"
    echo "  proxy config 127.0.0.1 7890 http"
    echo "  proxy on"
    echo "  proxy check"
}

function proxy_config() {
    local host=$1
    local port=$2
    local protocol=${3:-http} # Default to http if not specified

    if [[ -z "$host" || -z "$port" ]]; then
        echo "Error: Host and port are required."
        echo "Usage: proxy config <host> <port> [protocol]"
        return 1
    fi

    echo "PROXY_HOST=$host" > "$PROXY_CONFIG_FILE"
    echo "PROXY_PORT=$port" >> "$PROXY_CONFIG_FILE"
    echo "PROXY_PROTOCOL=$protocol" >> "$PROXY_CONFIG_FILE"
    
    echo "Proxy configuration saved to $PROXY_CONFIG_FILE"
    echo "Run 'proxy on' to apply settings."
}

function proxy_on() {
    if [[ ! -f "$PROXY_CONFIG_FILE" ]]; then
        echo "Error: Proxy not configured. Please run 'proxy config' first."
        return 1
    fi

    source "$PROXY_CONFIG_FILE"

    if [[ -z "$PROXY_HOST" || -z "$PROXY_PORT" ]]; then
        echo "Error: Invalid configuration file."
        return 1
    fi

    local proxy_url=""
    if [[ "$PROXY_PROTOCOL" == "socks5" ]]; then
        proxy_url="socks5://$PROXY_HOST:$PROXY_PORT"
    else
        proxy_url="http://$PROXY_HOST:$PROXY_PORT"
    fi

    # Set environment variables
    export http_proxy="$proxy_url"
    export https_proxy="$proxy_url"
    export ftp_proxy="$proxy_url"
    export all_proxy="$proxy_url"
    export HTTP_PROXY="$proxy_url"
    export HTTPS_PROXY="$proxy_url"
    export FTP_PROXY="$proxy_url"
    export ALL_PROXY="$proxy_url"
    
    # Set no_proxy for local addresses
    export no_proxy="localhost,127.0.0.1,localaddress,.local"
    export NO_PROXY="localhost,127.0.0.1,localaddress,.local"

    # Optional: Set GNOME proxy settings if gsettings is available
    if command -v gsettings &> /dev/null; then
        gsettings set org.gnome.system.proxy mode 'manual'
        gsettings set org.gnome.system.proxy.http host "$PROXY_HOST"
        gsettings set org.gnome.system.proxy.http port "$PROXY_PORT"
        gsettings set org.gnome.system.proxy.https host "$PROXY_HOST"
        gsettings set org.gnome.system.proxy.https port "$PROXY_PORT"
        gsettings set org.gnome.system.proxy.ftp host "$PROXY_HOST"
        gsettings set org.gnome.system.proxy.ftp port "$PROXY_PORT"
        if [[ "$PROXY_PROTOCOL" == "socks5" ]]; then
             gsettings set org.gnome.system.proxy.socks host "$PROXY_HOST"
             gsettings set org.gnome.system.proxy.socks port "$PROXY_PORT"
        fi
        echo "GNOME system proxy settings updated."
    fi

    echo "Proxy enabled: $proxy_url"
}

function proxy_off() {
    unset http_proxy https_proxy ftp_proxy all_proxy
    unset HTTP_PROXY HTTPS_PROXY FTP_PROXY ALL_PROXY
    unset no_proxy NO_PROXY

    if command -v gsettings &> /dev/null; then
        gsettings set org.gnome.system.proxy mode 'none'
        echo "GNOME system proxy settings disabled."
    fi

    echo "Proxy disabled."
}

function proxy_status() {
    echo "Current Proxy Environment Variables:"
    echo "http_proxy  : ${http_proxy:-Not Set}"
    echo "https_proxy : ${https_proxy:-Not Set}"
    echo "all_proxy   : ${all_proxy:-Not Set}"
    
    if [[ -f "$PROXY_CONFIG_FILE" ]]; then
        echo ""
        echo "Saved Configuration ($PROXY_CONFIG_FILE):"
        cat "$PROXY_CONFIG_FILE"
    else
        echo ""
        echo "No saved configuration."
    fi
}

function proxy_check() {
    echo "Checking proxy connection..."
    if [[ -z "$http_proxy" ]]; then
        echo "Warning: http_proxy environment variable is not set."
    fi
    
    # Test with curl
    local target="https://www.google.com"
    echo "Target: $target"
    
    http_code=$(curl -I -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "$target")
    
    if [[ "$http_code" == "200" || "$http_code" == "301" || "$http_code" == "302" ]]; then
        echo "Success: Proxy is working (HTTP $http_code)."
        
        # Optional: Show IP address
        echo "Checking public IP..."
        public_ip=$(curl -s --connect-timeout 5 ifconfig.me)
        if [[ -n "$public_ip" ]]; then
            echo "Public IP: $public_ip"
        else
            echo "Could not retrieve public IP."
        fi
    else
        echo "Failed: Unable to connect (HTTP $http_code)."
        echo "Trying alternative check (curl -v)..."
        curl -I --connect-timeout 5 "$target"
    fi
}

function proxy() {
    local cmd=$1
    shift

    case "$cmd" in
        on)
            proxy_on
            ;;
        off)
            proxy_off
            ;;
        status)
            proxy_status
            ;;
        check)
            proxy_check
            ;;
        config)
            proxy_config "$@"
            ;;
        help|--help|-h)
            proxy_help
            ;;
        *)
            proxy_help
            ;;
    esac
}

# Auto-complete setup (optional, simple version)
if [[ -n "$BASH_VERSION" ]]; then
    complete -W "on off status check config help" proxy
fi
