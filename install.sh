#!/bin/bash

# --- Colors & Styles ---
RESET="\033[0m"
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
MAGENTA="\033[35m"

# --- Functions ---

clear_screen() {
    printf "\033c"
}

header() {
    clear_screen
    echo -e "${CYAN}${BOLD}"
    echo "  ╔════════════════════════════════════════════╗"
    echo "  ║         FISH CONFIG INSTALLER            ║"
    echo "  ╚════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

draw_menu() {
    header
    echo -e "  Please select your environment:"
    echo ""
    echo -e "  ${GREEN}1.${RESET} Termux (Android)"
    echo -e "  ${GREEN}2.${RESET} Cardinals (Arch/CachyOS)"
    echo -e "  ${GREEN}3.${RESET} Exit"
    echo ""
    echo -n "  Enter choice [1-3]: "
}

setup_config() {
    echo -e "${BLUE}>> Setting up configuration...${RESET}"

    if [ ! -f "config.fish" ]; then
        echo -e "${RED}Error: config.fish not found in current directory.${RESET}"
        echo -e "${RED}Please run this script from the root of the repository.${RESET}"
        read -n 1 -s -r -p "Press any key to return..."
        return
    fi

    FISH_CONFIG_DIR="$HOME/.config/fish"

    # 1. Backup
    if [ -d "$FISH_CONFIG_DIR" ]; then
        BACKUP_DIR="${FISH_CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
        echo -e "${YELLOW}Backing up existing config to $BACKUP_DIR...${RESET}"
        mv "$FISH_CONFIG_DIR" "$BACKUP_DIR"
    fi

    # 2. Copy files
    echo -e "${BLUE}Copying new configuration...${RESET}"
    mkdir -p "$FISH_CONFIG_DIR"
    cp config.fish "$FISH_CONFIG_DIR/"
    cp -r functions "$FISH_CONFIG_DIR/"
    cp -r conf.d "$FISH_CONFIG_DIR/"
    cp -r completions "$FISH_CONFIG_DIR/"
    cp fish_plugins "$FISH_CONFIG_DIR/"

    # 3. Secrets
    if [ ! -f "$FISH_CONFIG_DIR/secrets.fish" ]; then
        if [ -f "secrets.fish.example" ]; then
             echo -e "${BLUE}Creating secrets.fish from example...${RESET}"
             cp secrets.fish.example "$FISH_CONFIG_DIR/secrets.fish"
             echo -e "${MAGENTA}IMPORTANT: Please edit ~/.config/fish/secrets.fish with your API keys!${RESET}"
        else
             echo -e "${RED}secrets.fish.example not found!${RESET}"
        fi
    fi

    # 4. Create directories
    echo -e "${BLUE}Creating ops directories...${RESET}"
    mkdir -p ~/ops/gems
    mkdir -p ~/ops/archive/raw

    echo -e "${GREEN}Configuration setup complete.${RESET}"
    sleep 1
}

post_install() {
    echo -e "${BLUE}>> Running post-install steps...${RESET}"

    # 1. Fisher update
    if command -v fish &> /dev/null; then
        echo -e "${BLUE}Updating Fisher plugins...${RESET}"
        # We need to ensure we run this in a non-interactive way if possible, or just let it run.
        # fisher update reads fish_plugins and installs them.
        fish -c "fisher update"
    else
        echo -e "${RED}Fish shell not found. Skipping fisher update.${RESET}"
    fi

    # 2. Change shell
    CURRENT_SHELL=$(basename "$SHELL")
    if [ "$CURRENT_SHELL" != "fish" ]; then
        echo -e "${YELLOW}Do you want to change your default shell to fish? (y/n)${RESET}"
        read -n 1 -p "Choice: " change_shell
        echo ""
        if [[ "$change_shell" == "y" ]]; then
            echo -e "${BLUE}Changing shell...${RESET}"
            chsh -s "$(command -v fish)"
            echo -e "${GREEN}Shell changed to fish. Please restart your session.${RESET}"
        fi
    fi

    echo -e "${MAGENTA}Installation Complete! Enjoy your new Fish config.${RESET}"
    echo -e "${MAGENTA}Please verify ~/.config/fish/secrets.fish and install gemini CLI if needed.${RESET}"
    read -n 1 -s -r -p "Press any key to return to menu..."
}

install_termux() {
    header
    echo -e "${YELLOW}>> Starting Termux Installation...${RESET}"

    if [ ! -d "/data/data/com.termux" ] && [ -z "$TERMUX_VERSION" ]; then
        echo -e "${RED}Warning: This does not look like a Termux environment.${RESET}"
        read -n 1 -p "Continue anyway? (y/n): " confirm
        if [[ "$confirm" != "y" ]]; then return; fi
        echo ""
    fi

    echo -e "${BLUE}Step 1: Updating packages...${RESET}"
    pkg update -y && pkg upgrade -y

    echo -e "${BLUE}Step 2: Installing core packages...${RESET}"
    PACKAGES="fish starship fastfetch python nodejs git fzf bat lsd openssh"
    echo -e "Installing: ${PACKAGES}"
    pkg install -y $PACKAGES

    if [ $? -ne 0 ]; then
        echo -e "${RED}Package installation failed.${RESET}"
        read -n 1 -s -r -p "Press any key to return..."
        return
    fi

    setup_config
    post_install
}

install_cardinals() {
    header
    echo -e "${YELLOW}>> Starting Cardinals (Arch) Installation...${RESET}"

    if ! command -v pacman &> /dev/null; then
        echo -e "${RED}Error: pacman not found. This option requires an Arch-based distro.${RESET}"
        read -n 1 -s -r -p "Press any key to return..."
        return
    fi

    echo -e "${BLUE}Step 1: Updating system...${RESET}"
    sudo pacman -Sy --noconfirm

    echo -e "${BLUE}Step 2: Installing core packages...${RESET}"
    PACKAGES="fish starship fastfetch python nodejs npm git fzf bat lsd"

    echo -e "Installing: ${PACKAGES}"
    if sudo pacman -S --noconfirm $PACKAGES; then
        echo -e "${GREEN}Core packages installed.${RESET}"
    else
        echo -e "${RED}Package installation failed.${RESET}"
        read -n 1 -s -r -p "Press any key to return..."
        return
    fi

    if pacman -Qq fnm &> /dev/null; then
        echo -e "${GREEN}fnm is already installed.${RESET}"
    else
        echo -e "${BLUE}Attempting to install fnm...${RESET}"
        if sudo pacman -S --noconfirm fnm; then
             echo -e "${GREEN}fnm installed via pacman.${RESET}"
        else
             echo -e "${YELLOW}fnm not found in official repos. Checking for AUR helpers...${RESET}"
             if command -v yay &> /dev/null; then
                 yay -S --noconfirm fnm-bin
             elif command -v paru &> /dev/null; then
                 paru -S --noconfirm fnm-bin
             else
                 echo -e "${RED}Could not install fnm. Please install fnm manually (AUR or cargo).${RESET}"
             fi
        fi
    fi

    setup_config
    post_install
}

# --- Main Loop ---

while true; do
    draw_menu
    read -n 1 choice
    echo ""

    case $choice in
        1)
            install_termux
            ;;
        2)
            install_cardinals
            ;;
        3)
            echo -e "${CYAN}Goodbye!${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option.${RESET}"
            sleep 1
            ;;
    esac
done
