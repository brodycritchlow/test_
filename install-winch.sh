#!/usr/bin/env sh

printf "\033[1;32mWinch Installation Script\033[0m\n\n"
printf "\033[1mThis script requires sudo.\033[0m\n\n"

# Prompt for sudo access at the start
sudo -v

# Keep sudo alive until the script finishes
while true; do sudo -n true; sleep 60; done 2>/dev/null &

# Define the URLs
LINUX_LATEST_BINARY_URL="https://github.com/Winch-Team/winch/releases/download/v0.1.0/winch-gnu-linux-x86_64"
MACOS_LATEST_BINARY_URL="https://github.com/Winch-Team/winch/releases/download/v0.1.0/winch-macos-x86_64"

ZSH_COMPLETION_URL="https://raw.githubusercontent.com/Winch-Team/install-winch/main/completions/_zsh"
BASH_COMPLETION_URL="https://raw.githubusercontent.com/Winch-Team/install-winch/main/completions/winch.bash"

# Ask for confirmation to proceed with installation
printf "\033[1;32mThis script will install Winch to the system. Continue? (Y/n) \033[0m"
read RESPONSE </dev/tty

if [ "$RESPONSE" = "y" ] || [ "$RESPONSE" = "Y" ] || [ -z "$RESPONSE" ]; then
    # Green
    printf "\033[1;32mInstalling Winch...\033[0m\n"

    # Ensure the destination directory exists
    mkdir -p "$HOME/.winch/bin"

    # Detect OS type using uname
    OS_TYPE=$(uname)

    if [ "$OS_TYPE" = "Linux" ]; then
        if [ "$SHELL" = "/usr/bin/zsh" ]; then
            mkdir -p "$HOME/.zsh/completions"

            sudo curl -fsSL "$ZSH_COMPLETION_URL" -o "$HOME/.zsh/completions/_winch" || { echo "Failed to download Zsh completion script"; exit 1; }

            if [ -f "$HOME/.zshrc" ]; then
                echo "fpath+=~/.zsh/completions" >> "$HOME/.zshrc"
                echo "autoload -Uz compinit && compinit" >> "$HOME/.zshrc"
            fi
        elif [ "$SHELL" = "/bin/bash" ]; then
            mkdir -p "$HOME/.bash/completions"

            sudo curl -fsSL "$BASH_COMPLETION_URL" -o "$HOME/.bash/completions/_winch.bash" || { echo "Failed to download Bash completion script"; exit 1; }

            if [ -f "$HOME/.bashrc" ]; then
                {
                    echo "if [ -d ~/.bash/completions ]; then"
                    echo "  for file in ~/.bash/completions/*.bash; do"
                    echo "    if [ -f \"\$file\" ]; then"
                    echo "      . \"\$file\""
                    echo "    fi"
                    echo "  done"
                    echo "fi"
                } >> "$HOME/.bashrc"
            fi
        fi
        curl -fsSL "$LINUX_LATEST_BINARY_URL" -o "$HOME/.winch/bin/winch" || { echo "Failed to download Linux binary"; exit 1; }
    elif [ "$OS_TYPE" = "Darwin" ]; then
        if [ "$SHELL" = "/usr/bin/zsh" ]; then
            mkdir -p "$HOME/.zsh/completions"
            curl -fsSL "$ZSH_COMPLETION_URL" -o "$HOME/.zsh/completions/_winch" || { echo "Failed to download Zsh completion script"; exit 1; }

            if [ -f "$HOME/.zshrc" ]; then
                echo "fpath+=~/.zsh/completions" >> "$HOME/.zshrc"
                echo "autoload -Uz compinit && compinit" >> "$HOME/.zshrc"
            fi
        elif [ "$SHELL" = "/bin/bash" ]; then
            mkdir -p "$HOME/.bash/completions"

            sudo curl -fsSL "$BASH_COMPLETION_URL" -o "$HOME/.bash/completions/_winch.bash" || { echo "Failed to download Bash completion script"; exit 1; }

            if [ -f "$HOME/.bashrc" ]; then
                {
                    echo "if [ -d ~/.bash/completions ]; then"
                    echo "  for file in ~/.bash/completions/*.bash; do"
                    echo "    if [ -f \"\$file\" ]; then"
                    echo "      . \"\$file\""
                    echo "    fi"
                    echo "  done"
                    echo "fi"
                } >> "$HOME/.bashrc"
            fi
        fi
        curl -fsSL "$MACOS_LATEST_BINARY_URL" -o "$HOME/.winch/bin/winch" || { echo "Failed to download macOS binary"; exit 1; }
    else
        echo "Unsupported OS type: $OS_TYPE"
        exit 1
    fi

    chmod +x "$HOME/.winch/bin/winch"

    printf "\033[1;32mSUCCESS!\033[0m Winch is now installed on the machine. Last step: add this to your shell profile:\nexport PATH=\$PATH:\$HOME/.winch/bin/ and restart your shell\n"
else
    printf "Exiting...\n"
    exit 1
fi

# End of script, stop the background sudo refresh
trap 'kill $(jobs -p)' EXIT
