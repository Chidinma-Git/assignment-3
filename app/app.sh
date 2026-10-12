#!/usr/bin/env bash

set -u

show_help() {
    echo "Diagnostic CLI"
    echo
    echo "Usage:"
    echo "  diagnostic system-info"
    echo "  diagnostic check-host <host>"
    echo "  diagnostic check-port <host> <port>"
    echo "  diagnostic help"
    echo
    echo "Commands:"
    echo "  system-info              Display system information"
    echo "  check-host <host>        Resolve and check a host"
    echo "  check-port <host> <port> Check TCP connectivity"
    echo "  help                     Display this help message"
}

system_info() {
    echo "======================================"
    echo "        SYSTEM INFORMATION"
    echo "======================================"
    echo "Hostname: $(hostname)"
    echo "User: $(whoami)"
    echo "Operating System: $(uname -s)"
    echo "Kernel: $(uname -r)"
    echo "Architecture: $(uname -m)"
    echo "Uptime: $(uptime)"
    echo "Current Directory: $(pwd)"
    echo "======================================"
}

check_host() {
    local host="$1"
    local address=""

    echo "======================================"
    echo "          HOST CHECK"
    echo "======================================"
    echo "Host: $host"

    if command -v getent >/dev/null 2>&1; then
        address=$(getent hosts "$host" 2>/dev/null | awk 'NR==1 {print $1}')
    elif command -v dscacheutil >/dev/null 2>&1; then
        address=$(dscacheutil -q host -a name "$host" 2>/dev/null \
            | awk '/^ip_address:/ {print $2; exit}')
    else
        echo "Error: no supported host-resolution command is available."
        return 1
    fi

    if [[ -z "$address" ]]; then
        echo "Error: unable to resolve host: $host"
        return 1
    fi

    echo "Resolved Address: $address"

    if command -v ping >/dev/null 2>&1; then
        if ping -c 1 -W 2 "$host" >/dev/null 2>&1; then
            echo "Status: Reachable"
            return 0
        else
            echo "Status: Unreachable"
            return 1
        fi
    fi

    echo "Status: Host resolved"
    return 0
}

check_port() {
    local host="$1"
    local port="$2"

    if ! [[ "$port" =~ ^[0-9]+$ ]]; then
        echo "Error: port must be numeric."
        return 2
    fi

    if (( port < 1 || port > 65535 )); then
        echo "Error: port must be between 1 and 65535."
        return 2
    fi

    echo "======================================"
    echo "           PORT CHECK"
    echo "======================================"
    echo "Host: $host"
    echo "Port: $port"

    if ! command -v nc >/dev/null 2>&1; then
        echo "Error: netcat (nc) is not available."
        return 1
    fi

    if nc -z -w 3 "$host" "$port" >/dev/null 2>&1; then
        echo "TCP Status: OPEN"
        return 0
    else
        echo "TCP Status: CLOSED or UNREACHABLE"
        return 1
    fi
}

if [[ $# -eq 0 ]]; then
    show_help
    exit 2
fi

command="$1"

case "$command" in
    system-info)
        [[ $# -eq 1 ]] || {
            echo "Error: system-info takes no arguments."
            exit 2
        }
        system_info
        ;;

    check-host)
        [[ $# -eq 2 ]] || {
            echo "Error: check-host requires a host."
            exit 2
        }
        check_host "$2"
        ;;

    check-port)
        [[ $# -eq 3 ]] || {
            echo "Error: check-port requires host and port."
            exit 2
        }
        check_port "$2" "$3"
        ;;

    help)
        [[ $# -eq 1 ]] || {
            echo "Error: help takes no arguments."
            exit 2
        }
        show_help
        ;;

    *)
        echo "Error: invalid command: $command"
        show_help
        exit 2
        ;;
esac
