# Dotfiles

Personal dotfiles for Arch Linux with Hyprland.

## Fresh Install

```bash
# Install base dependencies
sudo pacman -S --needed just git base-devel

# Install AUR helper (yay)
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay && makepkg -si

# Clone and setup dotfiles
git clone git@github.com:KiryuuLight/dotfiles-v2.git ~/dotfiles-v2
cd ~/dotfiles-v2
just setup
```

## Individual Tasks

```bash
just              # List available commands
just packages     # Install all packages (pacman + AUR)
just themes       # Setup GTK/Qt themes
just stow         # Symlink dotfiles
just sddm         # Setup login screen (requires sudo)
```

## What's Included

- **Hyprland** - Wayland compositor with waybar, rofi, mako, wlogout
- **Neovim** - Configured with LSP, treesitter, telescope
- **Kitty** - Terminal emulator
- **Zsh** - Shell with antidote, starship prompt, zoxide
- **Zellij** - Terminal multiplexer
- **Catppuccin Mocha** - Theme for GTK, Kvantum, icons, SDDM
