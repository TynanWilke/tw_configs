#!/bin/bash

set -e

DOTFILES_USER="${DOTFILES_USER:-tw}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

prompt_yes_no() {
    local message="$1"
    local response
    while true; do
        echo -ne "${YELLOW}[PROMPT]${NC} $message (y/n): "
        read -r response < /dev/tty
        case "$response" in
            [Yy]|[Yy][Ee][Ss]) return 0 ;;
            [Nn]|[Nn][Oo]) return 1 ;;
            *) echo "Please answer y or n." ;;
        esac
    done
}

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    log_error "This script is only for Linux. macOS does not need a separate user setup."
    exit 1
fi

if id "$DOTFILES_USER" &>/dev/null; then
    log_info "User '$DOTFILES_USER' already exists."
else
    if ! prompt_yes_no "User '$DOTFILES_USER' does not exist. Create user '$DOTFILES_USER' with group?"; then
        log_info "Skipping user creation."
        exit 0
    fi

    if ! command -v useradd &>/dev/null && ! command -v adduser &>/dev/null; then
        log_error "Neither useradd nor adduser found. Cannot create user."
        exit 1
    fi

    if command -v useradd &>/dev/null; then
        sudo useradd -m -s /bin/bash "$DOTFILES_USER"
    else
        sudo adduser --disabled-password --gecos "" "$DOTFILES_USER"
        sudo usermod -s /bin/bash "$DOTFILES_USER"
    fi

    local home_dir=$(eval echo "~$DOTFILES_USER")
    if [ ! -d "$home_dir" ]; then
        sudo mkdir -p "$home_dir"
        sudo chown "$DOTFILES_USER:$DOTFILES_USER" "$home_dir"
    fi

    if id "$DOTFILES_USER" &>/dev/null; then
        log_info "User '$DOTFILES_USER' created successfully."
    else
        log_error "Failed to create user '$DOTFILES_USER'."
        exit 1
    fi
fi

if prompt_yes_no "Set up passwordless sudo for user '$DOTFILES_USER'?"; then
    local sudoers_file="/etc/sudoers.d/$DOTFILES_USER"
    echo "$DOTFILES_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee "$sudoers_file" >/dev/null
    sudo chmod 440 "$sudoers_file"
    if sudo visudo -c -f "$sudoers_file" &>/dev/null; then
        log_info "Passwordless sudo configured for '$DOTFILES_USER'."
    else
        log_error "Sudoers file validation failed, removing $sudoers_file"
        sudo rm -f "$sudoers_file"
        exit 1
    fi
else
    log_info "Skipping passwordless sudo setup for '$DOTFILES_USER'."
fi

echo ""
log_info "User setup complete!"
log_info "Now log in as '$DOTFILES_USER' and run the install script:"
log_info "  curl -fsSL https://raw.githubusercontent.com/TynanWilke/tw_configs/main/install.sh | bash"
