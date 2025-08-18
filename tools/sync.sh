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

if [[ ! -d "$HOME/.dotfiles" ]]; then
    error "Dotfiles repository not found. Please run install.sh first"
    exit 1
fi

header "📂 Syncing dotfiles"

log "Pulling latest changes..."
DOTFILES_PULL_OUTPUT=$(dotfiles pull origin main 2>&1)

if echo "$DOTFILES_PULL_OUTPUT" | grep -q "Already up to date"; then
    success "Dotfiles are already up to date"
    dotfiles_updated=false
else
    warning "Updates pulled from remote repository"
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

if [[ -f "$HOME/.oh-my-zsh/tools/upgrade.sh" ]]; then
    "$HOME/.oh-my-zsh/tools/upgrade.sh" > /dev/null 2>&1
else
    warning "Oh My Zsh not found"
fi

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
