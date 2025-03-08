# Dotfiles

Personal configuration management using Git for a fully functional Arch Linux
environment.

This repository uses Git directly to manage dotfiles, following the "bare
repository" approach. For more information, check the [ArchWiki on
Dotfiles](https://wiki.archlinux.org/title/Dotfiles).

The only prequisite is a basic Arch Linux installation with an X window manager

## Installation

### Setup Steps

1. **Install Git**:

```bash
$ sudo pacman -S git
```

2. **Install Yay** (AUR package manager):

Follow the [official Yay installation guide](https://github.com/Jguer/yay?tab=readme-ov-file#installation)

3. **Clone and Configure the Dotfiles Repository**:

```bash
$ git clone --bare git@github.com:heiytor/dotfiles.git $HOME/.dotfiles
$ echo "alias dotfiles='/usr/bin/git --git-dir=\"\$HOME/.dotfiles/\" --work-tree=\"\$HOME\"'" >> $HOME/.bashrc
$ source $HOME/.bashrc
$ dotfiles checkout
$ dotfiles config --local status.showUntrackedFiles no
```

4. **Install Essential Packages**:

```bash
$ grep -v '^#\|^$' $HOME/.ensure-installed | yay -Syu --needed -
```

5. **Download ASDF**:

Follow the [official getting started guide](https://asdf-vm.com/guide/getting-started.html).
Install the binary in "$HOME/bin".

Then, install all required plugins:
```bash
$ asdf plugin add golang
$ asdf plugin add ruby
$ asdf plugin add nodejs
$ asdf plugin add python
$ asdf install # install all versions on "$HOME/.tool-verisons"
```

6. **Build Neovim**:

Follow the [official BUILD.md](https://github.com/neovim/neovim/blob/master/BUILD.md)

Then, update all the packages required:
```bash
$ nvim +"lua require('lazy').sync({wait=true}); vim.cmd('qa!')" && nvim -c ":TSUpdate" +qa && nvim -c ":MasonUpdate" +qa
```

7. **Start Docker**

```bash
$ sudo systemctl enable docker
$ sudo usermod -aG docker $USER
```

8. **Install Oh My Zsh with plugins and Set ZSH as Default Shell**:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

chsh -s $(which zsh)
```

9. **Finalize Setup**:

Restart the system
