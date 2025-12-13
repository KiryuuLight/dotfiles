#!/usr/bin/env bash

set -euo pipefail

GTK_REPO_URL="https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme.git"
GTK_TEMP_DIR="/tmp/catppuccin-gtk-theme"
PAPIRUS_FOLDERS_REPO_URL="https://github.com/catppuccin/papirus-folders.git"
PAPIRUS_FOLDERS_TEMP_DIR="/tmp/catppuccin-papirus-folders"
KVANTUM_REPO_URL="https://github.com/catppuccin/kvantum.git"
KVANTUM_TEMP_DIR="/tmp/catppuccin-kvantum"

install_catppuccin_gtk() {
    echo "Installing Catppuccin GTK Theme (Blue, Mocha)..."

    if [[ -d "$GTK_TEMP_DIR" ]]; then
        echo "Removing existing temp directory..."
        rm -rf "$GTK_TEMP_DIR"
    fi

    echo "Cloning repository..."
    git clone --depth 1 "$GTK_REPO_URL" "$GTK_TEMP_DIR"

    echo "Running install script..."
    cd "$GTK_TEMP_DIR/themes"
    ./install.sh -t blue -c dark

    rm -rf "$HOME/.themes/Catppuccin-Mocha"
    mv "$HOME/.themes/Catppuccin-Blue-Dark" "$HOME/.themes/Catppuccin-Mocha"

    echo "Cleaning up..."
    rm -rf "$GTK_TEMP_DIR"

    echo "Catppuccin GTK Theme installed as 'Catppuccin-Mocha'!"
}

install_papirus_icons() {
    echo "Installing Papirus icons with Catppuccin Mocha folders..."

    cd /tmp

    if [[ -d "$PAPIRUS_FOLDERS_TEMP_DIR" ]]; then
        echo "Removing existing temp directory..."
        rm -rf "$PAPIRUS_FOLDERS_TEMP_DIR"
    fi

    echo "Cloning catppuccin papirus-folders repository..."
    git clone --depth 1 "$PAPIRUS_FOLDERS_REPO_URL" "$PAPIRUS_FOLDERS_TEMP_DIR"

    echo "Downloading papirus-folders script..."
    curl -sLO https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/papirus-folders
    chmod +x ./papirus-folders

    echo "Creating Catppuccin-Mocha-Papirus icon theme..."
    rm -rf "$HOME/.local/share/icons/Catppuccin-Mocha-Papirus"
    mkdir -p "$HOME/.local/share/icons"
    cp -r /usr/share/icons/Papirus-Dark "$HOME/.local/share/icons/Catppuccin-Mocha-Papirus"

    echo "Installing Catppuccin folder colors..."
    find "$HOME/.local/share/icons/Catppuccin-Mocha-Papirus" -type l -name "places" -delete
    find "$HOME/.local/share/icons/Catppuccin-Mocha-Papirus" -maxdepth 1 -type l \( -name "32x32" -o -name "48x48" -o -name "64x64" \) -delete
    cp -r "$PAPIRUS_FOLDERS_TEMP_DIR/src/"* "$HOME/.local/share/icons/Catppuccin-Mocha-Papirus"

    ./papirus-folders -C cat-mocha-blue --theme "$HOME/.local/share/icons/Catppuccin-Mocha-Papirus"

    sed -i 's/Name=Papirus-Dark/Name=Catppuccin-Mocha-Papirus/' "$HOME/.local/share/icons/Catppuccin-Mocha-Papirus/index.theme"

    echo "Cleaning up..."
    rm -rf "$PAPIRUS_FOLDERS_TEMP_DIR"
    rm -f ./papirus-folders

    echo "Papirus icons installed as 'Catppuccin-Mocha-Papirus'!"
}

install_kvantum_theme() {
    echo "Installing Kvantum Catppuccin Mocha Blue theme..."

    cd /tmp

    if [[ -d "$KVANTUM_TEMP_DIR" ]]; then
        echo "Removing existing temp directory..."
        rm -rf "$KVANTUM_TEMP_DIR"
    fi

    echo "Cloning repository..."
    git clone --depth 1 "$KVANTUM_REPO_URL" "$KVANTUM_TEMP_DIR"

    echo "Installing theme..."
    mkdir -p "$HOME/.config/Kvantum"
    rm -rf "$HOME/.config/Kvantum/catppuccin-mocha"
    cp -r "$KVANTUM_TEMP_DIR/themes/catppuccin-mocha-blue" "$HOME/.config/Kvantum/catppuccin-mocha"

    sed -i 's/catppuccin-mocha-blue/catppuccin-mocha/g' "$HOME/.config/Kvantum/catppuccin-mocha/catppuccin-mocha-blue.kvconfig"
    mv "$HOME/.config/Kvantum/catppuccin-mocha/catppuccin-mocha-blue.kvconfig" "$HOME/.config/Kvantum/catppuccin-mocha/catppuccin-mocha.kvconfig"
    mv "$HOME/.config/Kvantum/catppuccin-mocha/catppuccin-mocha-blue.svg" "$HOME/.config/Kvantum/catppuccin-mocha/catppuccin-mocha.svg"

    echo "theme=catppuccin-mocha" > "$HOME/.config/Kvantum/kvantum.kvconfig"

    echo "Cleaning up..."
    rm -rf "$KVANTUM_TEMP_DIR"

    echo "Kvantum theme installed as 'catppuccin-mocha'!"
}

install_catppuccin_gtk
install_papirus_icons
install_kvantum_theme

echo "All themes installed!"
