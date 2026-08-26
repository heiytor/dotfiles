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

INSTALL_ERRORS=()

record_error() {
    INSTALL_ERRORS+=("$1")
    error "$1"
}

try() {
    local description="$1"
    shift

    if "$@"; then
        return 0
    fi

    record_error "$description"
    return 1
}

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
    success "Repository already cloned at $HOME/.dotfiles, skipping"
else
    log "Cloning bare repository..."
    git clone --bare https://github.com/heiytor/dotfiles.git "$HOME/.dotfiles"
    success "Repository cloned"
fi

# Dotfiles git wrapper function (needed before modules are available)
dotfiles() {
    /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

log "Checking out dotfiles..."

if ! checkout_output=$(dotfiles checkout 2>&1); then
    conflicts=$(printf '%s\n' "$checkout_output" | grep -E '^[[:space:]]+' | sed 's/^[[:space:]]*//')

    if [[ -z "$conflicts" ]]; then
        error "Checkout failed:"
        echo "$checkout_output"
        exit 1
    fi

    backup_dir="$HOME/dotfiles-backup-$(date +%Y%m%d)"
    warning "Some files already exist in \$HOME and would be overwritten"
    log "Backing them up to $backup_dir"

    while IFS= read -r file; do
        [[ -z "$file" ]] && continue
        mkdir -p "$backup_dir/$(dirname "$file")"
        mv "$HOME/$file" "$backup_dir/$file"
        log "Backed up $file"
    done <<< "$conflicts"

    if ! checkout_output=$(dotfiles checkout 2>&1); then
        error "Checkout failed after backing up conflicting files:"
        echo "$checkout_output"
        exit 1
    fi

    success "Dotfiles checked out (previous files saved in $backup_dir)"
else
    success "Dotfiles checked out successfully"
fi

log "Configuring dotfiles repository..."
dotfiles config --local status.showUntrackedFiles no
success "Dotfiles repository configured"

log "Loading modules..."
source "$HOME/.de-tools/modules/asdf.sh"
source "$HOME/.de-tools/modules/logger.sh"
source "$HOME/.de-tools/modules/packages.sh"

header "📦 Installing essential packages"

if sync_system_pkgs; then
    success "Essential packages installed"
else
    error ".de-config/ensure-installed file not found in dotfiles"
    exit 1
fi

header "🖥️ Configuring Ly display manager"

if ! systemctl is-enabled --quiet ly@tty2.service 2>/dev/null; then
    log "Enabling Ly to start automatically..."
    if try "Failed to enable ly@tty2.service" sudo systemctl enable ly@tty2.service; then
        success "Ly enabled"
    fi
else
    success "Ly is already enabled"
fi

header "🐳 Setting up Docker"

log "Enabling Docker service..."
if try "Failed to enable docker.service" sudo systemctl enable docker; then
    success "Docker service enabled"
fi

log "Adding user to docker group..."
sudo usermod -aG docker "$USER"
success "Docker configured (reboot required for group changes)"

header "⚡ System optimizations"

log "Checking for SSD devices..."
if grep -q 0 /sys/block/*/queue/rotational 2>/dev/null; then
    log "Non-rotational device detected → enabling fstrim.timer"
    if try "Failed to enable fstrim.timer" sudo systemctl enable --now fstrim.timer; then
        success "fstrim.timer enabled for SSD optimization"
    fi
else
    log "No non-rotational device detected → skipping fstrim.timer activation"
fi

log "Optimizing network boot behavior..."
if systemctl is-enabled --quiet systemd-networkd-wait-online.service 2>/dev/null; then
    log "Disabling systemd-networkd-wait-online.service for faster boot..."
    if try "Failed to disable systemd-networkd-wait-online.service" sudo systemctl disable systemd-networkd-wait-online.service \
        && try "Failed to mask systemd-networkd-wait-online.service" sudo systemctl mask systemd-networkd-wait-online.service; then
        success "Network wait service disabled (faster boot)"
    fi
else
    success "Network wait service already disabled"
fi

log "Configuring systemd-resolved (Cloudflare DNS with Google fallback)..."
if [[ -f "$HOME/.config/systemd/resolved.conf" ]]; then
    log "Copying resolved.conf to system directory..."
    sudo cp "$HOME/.config/systemd/resolved.conf" /etc/systemd/resolved.conf
    
    log "Restarting systemd-resolved..."
    try "Failed to restart systemd-resolved" sudo systemctl restart systemd-resolved || true
    
    success "DNS configured: Cloudflare (1.1.1.1) with Google (8.8.8.8) fallback"
else
    warning "resolved.conf not found in dotfiles, skipping DNS configuration"
fi

log "Solving SSH flakiness with MTU probing..."
echo "net.ipv4.tcp_mtu_probing=1" | sudo tee -a /etc/sysctl.d/99-sysctl.conf
success "TCP MTU probing enabled"

log "Optimizing power settings..."
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
    if try "Failed to enable de-battery-allert.timer" systemctl --user enable --now de-battery-allert.timer; then
        success "Battery monitoring enabled"
    fi
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
if sync_zsh_pkgs; then
    success "Zsh plugins installed"
else
    success "Zsh plugins already installed"
fi

log "Setting Zsh as default shell..."
sudo usermod -s "$(which zsh)" "$USER"
success "Zsh set as default shell"

header "🔧 Setting up asdf plugins"

asdf_status=0
setup_asdf || asdf_status=$?

case "$asdf_status" in
    0) success "asdf plugins setup completed" ;;
    1) warning ".tool-versions file not found, skipping asdf plugins" ;;
    *) record_error "Failed to install one or more asdf tools" ;;
esac

header "🎨 Configuring default theme"

rm -rf "$HOME/.de-config/themes/current"
ln -nsf "$HOME/.de-config/themes/simple-dark" "$HOME/.de-config/themes/current"

success "Default theme applied: simple-dark"

header "🎉 Finalizing setup"

if (( ${#INSTALL_ERRORS[@]} > 0 )); then
    warning "Installation finished with ${#INSTALL_ERRORS[@]} error(s)"
else
    success "Installation completed successfully!"
fi

echo
header "📋 Post-installation notes"

if (( ${#INSTALL_ERRORS[@]} > 0 )); then
    error "The following steps failed and need attention:"
    for install_error in "${INSTALL_ERRORS[@]}"; do
        echo -e "  ${RED}✗${NC} ${install_error}"
    done
    echo
fi

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

if (( ${#INSTALL_ERRORS[@]} > 0 )); then
    exit 1
fi
