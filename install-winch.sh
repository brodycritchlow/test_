#!/usr/bin/env bash

LINUX_LATEST_BINARY_URL="https://github.com/Winch-Team/winch/releases/download/v0.1.0/winch-gnu-linux-x86_64"
MACOS_LATEST_BINARY_URL="https://github.com/Winch-Team/winch/releases/download/v0.1.0/winch-macos-x86_64"

printf "\033[1;32mThis script will install Winch to the system. Continue? (Y/n) \033[0m"

read -r RESPONSE </dev/tty

if [[ "$RESPONSE" == "y" ]] || [[ "$RESPONSE" == "Y" ]] || [[ -z "$RESPONSE" ]]; then
    # Green
    printf "\033[1;32mInstalling Winch...\033[0m\n"

    mkdir -p "$HOME/.winch/bin"

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -fsSL "$LINUX_LATEST_BINARY_URL" -o "$HOME/.winch/bin/winch"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        curl -fsSL "$MACOS_LATEST_BINARY_URL" -o "$HOME/.winch/bin/winch"
    else
        echo "Unsupported OS type: $OSTYPE"
        exit 1
    fi

    chmod +x "$HOME/.winch/bin/winch"

    printf "\033[1;32mSUCCESS!\033[0m Winch is now installed on the machine. Last step: add this to your shell profile:\nexport PATH=\$PATH:\$HOME/.winch/bin/\n"
else
    printf "Exiting...\n"
    exit 1
fi
