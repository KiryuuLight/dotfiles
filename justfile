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
