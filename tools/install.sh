#!/usr/bin/env bash

set -e

# Basic color definitions (before modules are available)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Basic logging functions (before modules are available)
log() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[✓]${NC} $1"; }
warning() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; }
header() { echo -e "\n${BOLD}${BLUE}━━━ $1 ━━━${NC}\n"; }

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   error "This script should not be run as root"
   exit 1
fi

header "🚀 Dotfiles Installation for Arch Linux"
log "Setting up dotfiles on a fresh Arch installation"

header "📦 Installing base packages (Git, Yay)"

if ! command -v git &> /dev/null; then
    log "Installing Git..."
    sudo pacman -S --noconfirm git
    success "Git installed"
else
    success "Git already installed"
fi

if ! command -v yay &> /dev/null; then
    log "Installing Yay AUR helper..."
    sudo pacman -S --noconfirm --needed base base-devel
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$HOME"
    success "Yay installed"
else
    success "Yay already installed"
fi

header "📂 Cloning dotfiles repository"

if [[ -d "$HOME/.dotfiles" ]]; then
    error "Dotfiles directory already exists at $HOME/.dotfiles"
    exit 1
fi

log "Cloning bare repository..."
git clone --bare https://github.com/heiytor/dotfiles.git "$HOME/.dotfiles"
success "Repository cloned"

# Dotfiles git wrapper function (needed before modules are available)
dotfiles() {
    /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

log "Checking out dotfiles..."

checkout_output=$(dotfiles checkout 2>&1)
checkout_code=$?

if (( checkout_code == 0 )); then
    success "Dotfiles checked out successfully"
else
    error "Checkout failed:"
    echo "$checkout_output"
    exit 1
fi

log "Configuring dotfiles repository..."
dotfiles config --local status.showUntrackedFiles no
success "Dotfiles repository configured"

log "Loading modules..."
source "$HOME/tools/modules/asdf.sh"
source "$HOME/tools/modules/logger.sh"
source "$HOME/tools/modules/packages.sh"

header "📦 Installing essential packages"

if sync_system_pkgs; then
    success "Essential packages installed"
else
    error ".ensure-installed file not found in dotfiles"
    exit 1
fi

header "🖥️ Configuring Ly display manager"

if ! systemctl is-enabled --quiet ly.service 2>/dev/null; then
    log "Enabling Ly to start automatically..."
    sudo systemctl enable ly.service
    success "Ly enabled"
else
    success "Ly is already enabled"
fi

header "🐳 Setting up Docker"

log "Enabling Docker service..."
sudo systemctl enable docker

log "Adding user to docker group..."
sudo usermod -aG docker "$USER"
success "Docker configured (reboot required for group changes)"

header "⚡ System optimizations"

log "Checking for SSD devices..."
if grep -q 0 /sys/block/*/queue/rotational 2>/dev/null; then
    log "Non-rotational device detected → enabling fstrim.timer"
    sudo systemctl enable --now fstrim.timer
    success "fstrim.timer enabled for SSD optimization"
else
    log "No non-rotational device detected → skipping fstrim.timer activation"
fi

log "Optimizing network boot behavior..."
if systemctl is-enabled --quiet systemd-networkd-wait-online.service 2>/dev/null; then
    log "Disabling systemd-networkd-wait-online.service for faster boot..."
    sudo systemctl disable systemd-networkd-wait-online.service
    sudo systemctl mask systemd-networkd-wait-online.service
    success "Network wait service disabled (faster boot)"
else
    success "Network wait service already disabled"
fi

if ls /sys/class/power_supply/BAT* &>/dev/null; then
    success "Battery detected → Laptop/portable device"
    
    log "Setting balanced power profile for battery life..."
    if command -v powerprofilesctl &>/dev/null; then
        if command -v powerprofilesctl &>/dev/null; then
            if powerprofilesctl set balanced; then
                success "Power profile set to balanced"
            else
                warning "Failed to set power profile"
            fi
        fi
    fi
    
    log "Setting up battery monitoring..."
    systemctl --user enable --now omarchy-battery-monitor.timer || true
    success "Battery monitoring enabled"
else
    success "No battery detected → Desktop/workstation"
    
    log "Setting performance power profile for maximum performance..."
    if command -v powerprofilesctl &>/dev/null; then
        if powerprofilesctl set performance; then
            success "Power profile set to performance"
        else
            warning "Failed to set power profile"
        fi
    fi
fi

header "🔥 Configuring UFW Firewall"

log "Setting default policies..."
sudo ufw --force default deny incoming
success "Default deny incoming configured"

sudo ufw --force default allow outgoing
success "Default allow outgoing configured"

log "Allowing SSH access (port 22/tcp)..."
sudo ufw allow 22/tcp
success "SSH access allowed"

log "Allowing LocalSend ports (53317/tcp and 53317/udp)..."
sudo ufw allow 53317/tcp
sudo ufw allow 53317/udp
success "LocalSend ports allowed"

log "Allowing Docker DNS resolution..."
sudo ufw allow in on docker0 to any port 53
success "Docker DNS resolution allowed"

log "Enabling firewall..."
sudo ufw --force enable
success "UFW firewall enabled"

log "Installing Docker-specific UFW protections..."
sudo ufw-docker install
success "UFW-Docker protections installed"

log "Reloading firewall rules..."
sudo ufw reload
success "Firewall rules reloaded"

success "Firewall configuration completed"

header "⚡ Setting up Neovim packages"

if sync_nvim_pkgs; then
    success "Neovim packages updated"
fi

header "🐚 Installing Oh My Zsh and plugins"

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    success "Oh My Zsh installed"
else
    success "Oh My Zsh already installed"
fi

log "Installing Zsh plugins..."
if install_zsh_pkgs; then
    success "Zsh plugins installed"
else
    success "Zsh plugins already installed"
fi

log "Setting Zsh as default shell..."
sudo usermod -s "$(which zsh)" "$USER"
success "Zsh set as default shell"

header "🔧 Setting up asdf plugins"

if setup_asdf; then
    success "asdf plugins setup completed"
else
    warning ".tool-versions file not found, skipping asdf plugins"
fi

header "🎨 Configuring default theme"

rm -rf "$HOME/themes/current"
ln -nsf "$HOME/themes/simple-dark" "$HOME/themes/current"

success "Default theme applied: simple-dark"

header "🎉 Finalizing setup"

success "Installation completed successfully!"

echo
header "📋 Post-installation notes"
warning "Please reboot your system to ensure all changes take effect"
echo
success "Enjoy your new setup! 🚀"

echo
read -r -p "Would you like to reboot now? (y/N): " REPLY </dev/tty
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log "Rebooting system..."
    sleep 2
    sudo reboot
else
    warning "Remember to reboot later to complete the setup!"
fi
