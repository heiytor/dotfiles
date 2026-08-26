#!/usr/bin/env bash

set -e

# Load modules
source "$HOME/.de-tools/modules/asdf.sh"
source "$HOME/.de-tools/modules/logger.sh"
source "$HOME/.de-tools/modules/packages.sh"

SYNC_ERRORS=()

record_error() {
    SYNC_ERRORS+=("$1")
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

revision_before=$(dotfiles rev-parse HEAD 2>/dev/null || echo unknown)
dotfiles_updated=false

if try "Failed to pull the dotfiles repository" dotfiles pull origin main; then
    revision_after=$(dotfiles rev-parse HEAD 2>/dev/null || echo unknown)

    if [[ "$revision_before" == "$revision_after" ]]; then
        success "Dotfiles are already up to date"
    else
        warning "Updates pulled from remote repository"
        dotfiles_updated=true
    fi
fi

header "📦 Updating essential packages"

if sync_system_pkgs; then
    success "Packages updated"
else
    record_error "Could not update packages from .de-config/ensure-installed"
fi

header "🧩 Rebuilding Hyprland plugins"

if ! command -v hyprpm &> /dev/null; then
    log "hyprpm not found, skipping Hyprland plugins"
elif try "Failed to rebuild Hyprland plugins (hyprpm update)" hyprpm update; then
    success "Plugins rebuilt against the current Hyprland version"
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
    if "$HOME/.oh-my-zsh/tools/upgrade.sh" > /dev/null 2>&1; then
        success "Oh My Zsh updated"
    else
        record_error "Failed to upgrade Oh My Zsh"
    fi
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

asdf_status=0
setup_asdf || asdf_status=$?

case "$asdf_status" in
    0) success "asdf plugins updated" ;;
    1) log "No .tool-versions file, skipping asdf plugins" ;;
    *) record_error "Failed to install one or more asdf tools" ;;
esac

header "✨ Sync Complete"

if [[ "$dotfiles_updated" == true ]]; then
    success "Your dotfiles have been updated!"
    log "Changes pulled from remote repository"
else
    success "Everything is already up to date!"
fi

if (( ${#SYNC_ERRORS[@]} > 0 )); then
    echo
    error "The following steps failed and need attention:"
    for sync_error in "${SYNC_ERRORS[@]}"; do
        echo -e "  ${RED}✗${NC} ${sync_error}"
    done
fi

echo
log "To see what changed, run: dotfiles log HEAD@{1}..HEAD"
log "To view status, run: dotfiles status"

if [[ -t 0 && -t 1 ]]; then
    log "Reloading Zsh configuration..."
    exec zsh
fi

if (( ${#SYNC_ERRORS[@]} > 0 )); then
    exit 1
fi
