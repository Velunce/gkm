#!/bin/bash

# Set installation directory and target file
GKM_DIR="$HOME/.gkm"
GKM_SCRIPT="$GKM_DIR/gkm.sh"
ALIAS_NAME="gkm"
GITHUB_URL="https://raw.githubusercontent.com/Velunce/gkm/main/gkm.sh" # Update this URL to your repo

# Function to check if gkm is already installed
function check_installed {
    if [ -f "$GKM_SCRIPT" ]; then
        echo "gkm is already installed at $GKM_SCRIPT"
        return 0
    else
        return 1
    fi
}

# Function to add the alias to the shell profile
function add_alias {
    local shell_profile="$1"
    if [ -f "$shell_profile" ]; then
        if ! grep -q "alias $ALIAS_NAME" "$shell_profile"; then
            echo "Adding alias 'gkm' to $shell_profile..."
            echo "alias $ALIAS_NAME='$GKM_SCRIPT'" >> "$shell_profile"
        fi
    fi
}

# Function to install gkm
function install_gkm {
    echo "Installing gkm..."

    # Create the installation directory if it doesn't exist
    mkdir -p "$GKM_DIR"

    # Download the latest gkm.sh script from GitHub
    echo "Downloading gkm.sh from GitHub..."
    if ! curl -sSL "$GITHUB_URL" -o "$GKM_SCRIPT"; then
        echo "Download failed. Please check your internet connection or the URL."
        exit 1
    fi

    # Make the script executable
    chmod +x "$GKM_SCRIPT"

    # Add gkm alias to the shell profile for bash, zsh, etc.
    for shell_profile in "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.zshrc" "$HOME/.profile"; do
        add_alias "$shell_profile"
    done

    echo "Installation complete. Please run 'source ~/.bashrc' or 'source ~/.zshrc' (depending on your shell) to start using 'gkm'."
}

# Main logic
if check_installed; then
    echo "Do you want to reinstall gkm? (y/n)"
    read -rp "> " answer
    case "$answer" in
        y|Y) install_gkm ;;
        n|N) echo "Installation aborted."; exit 0 ;;
        *) echo "Invalid input. Please enter 'y' or 'n'." ;;
    esac
else
    install_gkm
fi
