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

5. **Build Neovim**:

Follow the [official BUILD.md](https://github.com/neovim/neovim/blob/master/BUILD.md)

6. **Install Oh My Zsh and Set ZSH as Default Shell**:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh)
```

7. **Download ASDF**:

Follow the [official getting started guide](https://asdf-vm.com/guide/getting-started.html).
Install the binary in "$HOME/bin". Then, install all required plugins:
```bash
$ asdf plugin add golang
$ asdf plugin add ruby
$ asdf install # install all versions on "$HOME/.tool-verisons"
```

8. **Iniatialize the Docker**

```bash
$ sudo systemctl enable docker
$ sudo usermod -aG docker $USER
```

8. **Finalize Setup**:

Restart the system
