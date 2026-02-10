# Dotfiles setup with just

# Default: show available commands
default:
    @just --list

# Full setup: packages -> stow -> shell -> npm tools -> themes -> sddm -> firefox
setup: packages stow shell npm-tools themes sddm firefox-theme
    @echo "Setup complete!"

# Install all packages (pacman + AUR)
packages: packages-pacman packages-aur

# Install official repo packages
packages-pacman:
    @echo "Installing pacman packages..."
    grep -v '^#' packages/pacman.txt | grep -v '^$' | sudo pacman -S --needed -

# Install AUR packages
packages-aur:
    #!/usr/bin/env bash
    set -euo pipefail
    aur_helper=$(command -v yay || command -v paru || echo "")
    if [[ -z "$aur_helper" ]]; then
        echo "Error: No AUR helper found (yay or paru required)"
        exit 1
    fi
    echo "Installing AUR packages with $aur_helper..."
    grep -v '^#' packages/aur.txt | grep -v '^$' | xargs $aur_helper -S --needed --noconfirm || true

# Install global npm packages (requires mise + node)
npm-tools:
    mise install
    mise exec -- npm install -g markdownlint-cli2 @fsouza/prettierd

# Install GTK, Kvantum, and icon themes
themes:
    ./scripts/themes.sh

# Symlink dotfiles with stow
stow:
    stow --adopt -v -R -t ~ .
    git restore .

# Set zsh as default shell
shell:
    #!/usr/bin/env bash
    if [[ "$SHELL" != */zsh ]]; then
        echo "Setting zsh as default shell..."
        chsh -s /usr/bin/zsh
        echo "Shell changed. Log out and back in for it to take effect."
    else
        echo "zsh is already the default shell"
    fi

# SDDM login screen setup (requires sudo)
sddm:
    ./sddm/setup.sh

# Firefox Catppuccin Mocha Blue theme
firefox-theme:
    ./scripts/firefox-theme.sh

# System tweaks: zram, sysctl, earlyoom, r8125 driver (requires sudo)
system-tweaks:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "Configuring zram (ram/2, zstd)..."
    printf '[zram0]\nzram-size = ram / 2\ncompression-algorithm = zstd\n' | sudo tee /etc/systemd/zram-generator.conf
    echo "Configuring sysctl (zram tuning + overcommit)..."
    printf 'vm.swappiness = 180\nvm.watermark_boost_factor = 0\nvm.watermark_scale_factor = 125\nvm.page-cluster = 0\nvm.overcommit_memory = 0\n' | sudo tee /etc/sysctl.d/99-vm-zram-parameters.conf
    echo "Configuring earlyoom..."
    sudo sed -i 's/^EARLYOOM_ARGS=.*/EARLYOOM_ARGS="-m 5 -s 5 --prefer '"'"'(^|\\/)(node|claude)$$'"'"' --avoid '"'"'(^|\\/)(Xorg|Xwayland|sway|hyprland|sshd|systemd)$$'"'"' -n"/' /etc/default/earlyoom
    sudo systemctl enable --now earlyoom
    echo "Blacklisting r8169 (using r8125 driver instead)..."
    printf 'blacklist r8169\n' | sudo tee /etc/modprobe.d/blacklist-r8169.conf
    sudo dkms autoinstall
    echo "Done! Reboot to apply zram + sysctl changes."
