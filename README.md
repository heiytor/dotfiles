# 🚀 Dotfiles

Personal configuration management using Git for a fully functional Arch Linux environment with automated installation.

This repository uses Git directly to manage dotfiles, following the **"bare repository"** approach. For more information, check the [ArchWiki on Dotfiles](https://wiki.archlinux.org/title/Dotfiles).

### One-Command Install

```bash
curl -fsSL https://raw.githubusercontent.com/heiytor/dotfiles/main/tools/install.sh | bash
```

### Manual Installation

1. **Download the installer:**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/heiytor/dotfiles/main/tools/install.sh -o install.sh
   chmod +x install.sh
   ```

2. **Run the installer:**
   ```bash
   ./install.sh
   ```

3. **Reboot your system:**
   ```bash
   sudo reboot
   ```

## 🎮 Usage

### Managing Dotfiles

```bash
# Check status
dotfiles status

# Add new config
dotfiles add .config/newapp/config.conf

# Commit changes
dotfiles commit -m "Add new application config"

# Push to repository
dotfiles push
```

### Recovery

```bash
# Reset to last known good state
dotfiles reset --hard HEAD

# Restore from backup
cp -r ~/dotfiles-backup-YYYYMMDD/.config ~/
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
