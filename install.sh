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

# Create dotfiles function for this session
dotfiles() {
    /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

# Check if .dotfiles already exists and if it's a valid git repository
if [[ -d "$HOME/.dotfiles" ]]; then
    if git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" status &>/dev/null; then
        warning "Valid dotfiles repository already exists"
        log "Fetching latest changes..."
        dotfiles fetch origin
        
        # Get the current branch name
        CURRENT_BRANCH=$(dotfiles symbolic-ref --short HEAD 2>/dev/null || dotfiles rev-parse --abbrev-ref HEAD)
        log "Current branch: $CURRENT_BRANCH"
        
        # Get the default remote branch
        DEFAULT_BRANCH=$(dotfiles symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
        
        # If we couldn't get the default branch, try to detect it
        if [[ -z "$DEFAULT_BRANCH" ]]; then
            log "Detecting default branch..."
            dotfiles remote set-head origin --auto &>/dev/null || true
            DEFAULT_BRANCH=$(dotfiles symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
        fi
        
        # If still no default branch, use the current branch
        if [[ -z "$DEFAULT_BRANCH" ]]; then
            DEFAULT_BRANCH="$CURRENT_BRANCH"
        fi
        
        log "Remote branch: origin/$DEFAULT_BRANCH"
        
        # Check if there are updates
        LOCAL=$(dotfiles rev-parse HEAD)
        REMOTE=$(dotfiles rev-parse "origin/$DEFAULT_BRANCH" 2>/dev/null || echo "")
        
        if [[ -n "$REMOTE" && "$LOCAL" != "$REMOTE" ]]; then
            warning "Updates available from remote repository"
            read -p "Pull latest changes? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                dotfiles pull origin "$DEFAULT_BRANCH"
                success "Repository updated"
            fi
        elif [[ -z "$REMOTE" ]]; then
            warning "Could not check for remote updates (branch may not exist on remote)"
        else
            success "Repository is up to date"
        fi
    else
        warning "Invalid dotfiles directory exists. Backing up..."
        mv "$HOME/.dotfiles" "$HOME/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)"
        log "Cloning bare repository..."
        git clone --bare https://github.com/heiytor/dotfiles.git "$HOME/.dotfiles"
        success "Repository cloned"
    fi
else
    log "Cloning bare repository..."
    git clone --bare https://github.com/heiytor/dotfiles.git "$HOME/.dotfiles"
    success "Repository cloned"
fi

header "⚙️  Setting up dotfiles alias"

if ! grep -q 'alias dotfiles=' "$HOME/.bashrc" 2>/dev/null; then
    log "Adding dotfiles alias to .bashrc..."
    echo 'alias dotfiles="/usr/bin/git --git-dir=\"\$HOME/.dotfiles/\" --work-tree=\"\$HOME\""' >> "$HOME/.bashrc"
    success "Dotfiles alias added to .bashrc"
else
    success "Dotfiles alias already exists in .bashrc"
fi

log "Sourcing .bashrc..."
source "$HOME/.bashrc" 2>/dev/null || true

header "💾 Backing up existing files and checking out dotfiles"

log "Creating backup directory for existing files..."
mkdir -p "$HOME/.backup"

# Function to handle symlink conflicts intelligently
handle_symlink_conflicts() {
    local file="$1"
    local backup_dir="$2"
    
    if [[ -L "$HOME/$file" ]]; then
        # It's a symlink
        local target=$(readlink "$HOME/$file")
        local abs_target=""
        
        # Check if target is relative or absolute
        if [[ "$target" = /* ]]; then
            # Absolute path
            abs_target="$target"
        else
            # Relative path - resolve it relative to the symlink's directory
            local symlink_dir=$(dirname "$HOME/$file")
            abs_target=$(cd "$symlink_dir" && realpath "$target" 2>/dev/null || echo "$symlink_dir/$target")
        fi
        
        # Check if the symlink target is within HOME (likely part of dotfiles)
        if [[ "$abs_target" == "$HOME"/* ]]; then
            # Convert to relative path from HOME
            local relative_target="${abs_target#$HOME/}"
            
            # Check if this target will be created by the dotfiles checkout
            # We do this by checking if the target path exists in the git repository
            if dotfiles ls-tree HEAD --name-only "$relative_target" 2>/dev/null | grep -q .; then
                log "  → Symlink points to dotfiles content: $relative_target"
                log "  → Removing symlink (will be recreated by checkout)"
                rm -f "$HOME/$file"
                return 0
            fi
        fi
        
        # If we get here, it's a symlink to something outside dotfiles
        # or to something that won't be created by checkout
        log "  → Backing up symlink: $file -> $target"
        local file_dir=$(dirname "$file")
        if [[ "$file_dir" != "." ]]; then
            mkdir -p "$backup_dir/$file_dir" 2>/dev/null || true
        fi
        mv "$HOME/$file" "$backup_dir/$file" 2>/dev/null || {
            error "Failed to backup $file"
            return 1
        }
    else
        # Regular file or directory
        log "  → Backing up: $file"
        local file_dir=$(dirname "$file")
        if [[ "$file_dir" != "." ]]; then
            mkdir -p "$backup_dir/$file_dir" 2>/dev/null || true
        fi
        mv "$HOME/$file" "$backup_dir/$file" 2>/dev/null || {
            error "Failed to backup $file"
            return 1
        }
    fi
    
    return 0
}

# First, check the current status
log "Checking repository status..."

# Temporarily disable set -e for this check
set +e
dotfiles_status=$(dotfiles status --porcelain 2>/dev/null)
status_check_result=$?
set -e

if [[ $status_check_result -ne 0 ]]; then
    log "Repository needs initial checkout"
    needs_checkout=true
elif [[ -z "$dotfiles_status" ]]; then
    success "Dotfiles are already checked out and up to date"
    needs_checkout=false
else
    log "Repository has uncommitted changes or needs checkout"
    needs_checkout=true
fi

if [[ "$needs_checkout" == "true" ]]; then
    log "Attempting to checkout dotfiles..."
    
    # Try checkout and capture both stdout and stderr
    set +e
    checkout_output=$(dotfiles checkout 2>&1)
    checkout_status=$?
    set -e
    
    if [[ $checkout_status -eq 0 ]]; then
        success "Checkout successful"
    else
        warning "Checkout failed, checking for conflicts..."
        
        if echo "$checkout_output" | grep -q "would be overwritten"; then
            warning "Conflicting files found. Analyzing conflicts..."
            
            backup_dir="$HOME/.backup/$(date +%Y%m%d_%H%M%S)"
            mkdir -p "$backup_dir"
            
            # Extract conflicting files more reliably
            conflicting_files=$(echo "$checkout_output" | grep -E "^\s+" | sed 's/^[[:space:]]*//' | grep -v "^Please" | grep -v "^Aborting")
            
            if [[ -n "$conflicting_files" ]]; then
                log "Found conflicting files:"
                echo "$conflicting_files"
                
                # Process each conflicting file
                echo "$conflicting_files" | while IFS= read -r file; do
                    if [[ -n "$file" && -e "$HOME/$file" ]]; then
                        handle_symlink_conflicts "$file" "$backup_dir"
                    fi
                done
                
                log "Retrying checkout after handling conflicts..."
                
                # Try checkout again
                set +e
                checkout_output=$(dotfiles checkout 2>&1)
                checkout_status=$?
                set -e
                
                if [[ $checkout_status -eq 0 ]]; then
                    success "Checkout successful after handling conflicts"
                else
                    # If still failing, might need multiple passes for complex symlink chains
                    warning "Still have conflicts, trying another pass..."
                    
                    # Extract remaining conflicts
                    remaining_conflicts=$(echo "$checkout_output" | grep -E "^\s+" | sed 's/^[[:space:]]*//' | grep -v "^Please" | grep -v "^Aborting")
                    
                    if [[ -n "$remaining_conflicts" ]]; then
                        echo "$remaining_conflicts" | while IFS= read -r file; do
                            if [[ -n "$file" && -e "$HOME/$file" ]]; then
                                handle_symlink_conflicts "$file" "$backup_dir"
                            fi
                        done
                        
                        # Final checkout attempt
                        if dotfiles checkout; then
                            success "Checkout successful after second pass"
                        else
                            error "Checkout still failing after handling symlinks"
                            log "You may need to manually resolve conflicts"
                            log "Check: dotfiles status"
                            exit 1
                        fi
                    fi
                fi
            else
                error "Could not identify conflicting files"
                echo "$checkout_output"
                exit 1
            fi
        else
            error "Checkout failed for unknown reason:"
            echo "$checkout_output"
            exit 1
        fi
    fi
fi

log "Configuring dotfiles repository..."
dotfiles config --local status.showUntrackedFiles no
success "Dotfiles repository configured"

header "📦 Installing essential packages"

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
sudo usermod -s "$(which zsh)" "$USER"
success "Zsh set as default shell"

# Final setup
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
