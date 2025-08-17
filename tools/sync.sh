#!/usr/bin/env bash

set -e

# Helper function for safe command execution
safe() {
    set +e
    "$@"
    local status=$?
    set -e
    return $status
}

# Load modules
source "$HOME/tools/modules/asdf.sh"
source "$HOME/tools/modules/logger.sh"
source "$HOME/tools/modules/packages.sh"

if [[ $EUID -eq 0 ]]; then
    error "This script should not be run as root"
    exit 1
fi

header "🔄 Syncing Dotfiles Configuration"
log "Updating your system with latest dotfiles changes"

header "📂 Fetching latest dotfiles"

if [[ ! -d "$HOME/.dotfiles" ]]; then
    error "Dotfiles repository not found. Please run install.sh first"
    exit 1
fi

log "Checking for remote updates..."
dotfiles fetch origin

LOCAL=$(dotfiles rev-parse HEAD)
REMOTE=$(safe dotfiles rev-parse "@{u}" 2>/dev/null || echo "")

if [[ -z "$REMOTE" ]]; then
    error "Could not find remote branch. Please check your repository setup"
    exit 1
fi

dotfiles_updated=false
if [[ "$LOCAL" == "$REMOTE" ]]; then
    success "Dotfiles are already up to date"
else
    warning "Updates available from remote repository"

    if [[ -n "$(dotfiles status --porcelain)" ]]; then
        error "You have uncommitted local changes"
        log "Please commit or stash your changes first"
        dotfiles status --short
        exit 1
    fi

    log "Pulling latest changes..."
    dotfiles pull origin main
    success "Dotfiles updated and applied successfully"

    dotfiles_updated=true
fi

header "📦 Updating essential packages"

if sync_system_pkgs; then
    success "Packages updated"
else
    warning "Could not update packages from .ensure-installed"
fi

header "⚡ Updating Neovim packages"

if sync_nvim_pkgs; then
    success "Neovim packages updated"
else
    log "Neovim not found or packages already up to date"
fi

header "🐚 Updating Oh My Zsh and plugins"

log "Updating Oh My Zsh..."
omz update > /dev/null 2>&1

log "Updating Zsh plugins..."
if sync_zsh_pkgs; then
    success "New Zsh plugins installed"
else
    success "Zsh plugins already up to date"
fi

header "🔧 Updating asdf plugins"
if setup_asdf; then
    success "asdf plugins updated"
else
    log "No .tool-versions file or plugins already configured"
fi

header "✨ Sync Complete"

if [[ "$dotfiles_updated" == true ]]; then
    success "Your dotfiles have been updated!"
    log "Changes pulled from remote repository"
else
    success "Everything is already up to date!"
fi

echo
log "To see what changed, run: dotfiles log HEAD@{1}..HEAD"
log "To view status, run: dotfiles status"

log "Reloading Zsh configuration..."
exec zsh
