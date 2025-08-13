#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[✓]${NC} $1"; }
warning() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; }
header() { echo -e "\n${BOLD}${BLUE}━━━ $1 ━━━${NC}\n"; }

if [[ $EUID -eq 0 ]]; then
   error "This script should not be run as root"
   exit 1
fi

header "🚀 Dotfiles Installation for Arch Linux"
log "Setting up dotfiles on a fresh Arch installation"
log "Repository: https://github.com/heiytor/dotfiles"

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
    warning "Dotfiles directory already exists. Backing up..."
    mv "$HOME/.dotfiles" "$HOME/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)"
fi

log "Cloning bare repository..."
git clone --bare https://github.com/heiytor/dotfiles.git "$HOME/.dotfiles"

header "⚙️  Setting up dotfiles alias"

log "Adding dotfiles alias to .bashrc..."
echo 'alias dotfiles="/usr/bin/git --git-dir=\"\$HOME/.dotfiles/\" --work-tree=\"\$HOME\""' >> "$HOME/.bashrc"

log "Creating dotfiles function for this session..."
dotfiles() {
    /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

log "Sourcing .bashrc..."
source "$HOME/.bashrc" 2>/dev/null || true

header "💾 Backing up existing files and checking out dotfiles"

log "Creating backup directory for existing files..."
mkdir -p "$HOME/.config-backup"

log "Attempting to checkout dotfiles..."
if ! dotfiles checkout 2>/dev/null; then
    warning "Conflicting files found. Moving them to backup..."
    dotfiles checkout 2>&1 | egrep "\s+\." | awk '{print $1}' | while read file; do
        if [[ -f "$HOME/$file" ]] || [[ -d "$HOME/$file" ]]; then
            log "Backing up: $file"
            mkdir -p "$HOME/.config-backup/$(dirname "$file")"
            mv "$HOME/$file" "$HOME/.config-backup/$file"
        fi
    done

    log "Retrying checkout..."
    dotfiles checkout
fi
success "Dotfiles checked out successfully"

log "Configuring dotfiles repository..."
dotfiles config --local status.showUntrackedFiles no
success "Dotfiles repository configured"

header "📦 Installing essential packages"
#
if [[ -f "$HOME/.ensure-installed" ]]; then
    log "Found .ensure-installed file. Installing packages..."
    log "This may take a while depending on your internet connection..."

    grep -v '^#\|^$' "$HOME/.ensure-installed" | yay -S --needed --noconfirm -
    success "Essential packages installed"
else
    error ".ensure-installed file not found in dotfiles"
    exit 1
fi

header "⚡ Setting up Neovim packages"

if command -v nvim &> /dev/null; then
    nvim --headless +"lua require('lazy').sync({wait=true})" +qa 2>/dev/null || true
    nvim --headless +TSUpdate +qa 2>/dev/null || true
    nvim --headless +MasonUpdate +qa 2>/dev/null || true
    success "Neovim packages updated"
fi

header "🐳 Setting up Docker"

log "Enabling Docker service..."
sudo systemctl enable docker

log "Adding user to docker group..."
sudo usermod -aG docker "$USER"
success "Docker configured (reboot required for group changes)"

header "🐚 Installing Oh My Zsh and plugins"

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    success "Oh My Zsh installed"
else
    success "Oh My Zsh already installed"
fi

log "Installing Zsh plugins..."

# Syntax highlighting
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi

# Autosuggestions
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi

success "Zsh plugins installed"

log "Setting Zsh as default shell..."
chsh -s "$(which zsh)"
success "Zsh set as default shell"

# Step 10: Final setup
header "🎉 Finalizing setup"

# Source the new shell configuration
log "Sourcing new configuration..."
source "$HOME/.bashrc" 2>/dev/null || true

success "Installation completed successfully!"

echo
header "📋 Post-installation notes"
warning "Please reboot your system to ensure all changes take effect"
log "After reboot:"
log "  • Docker group changes will be active"
log "  • Zsh will be your default shell"
log "  • All dotfiles configurations will be loaded"
echo
log "To manage your dotfiles, use: dotfiles <git-command>"
log "Example: dotfiles status, dotfiles add, dotfiles commit, etc."
echo
success "Enjoy your new setup! 🚀"

echo
read -p "Would you like to reboot now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log "Rebooting system..."
    sudo reboot
else
    warning "Remember to reboot later to complete the setup!"
fi
