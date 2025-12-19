#!/usr/bin/env bash

# Install Firefox extensions and Catppuccin Mocha Blue theme
# Extensions are installed via policies.json (fully automated)
# Theme requires Firefox Color (one-click install)

THEME_URL="https://color.firefox.com/?theme=XQAAAAJDBAAAAAAAAABBqYhm849SCicxcUcPX38oKRicm6da8pFtMcajvXaAE3RJ0F_F447xQs-L1kFlGgDKq4IIvWciiy4upusW7OvXIRinrLrwLvjXB37kvhN5ElayHo02fx3o8RrDShIhRpNiQMOdww5V2sCMLAfehho7r-AtSBPnvx4uvv7vRnzG2zBiFpesm1SAl1KsPscTY8iQYgDnBUvUwxRg5oKKrqaQ_z3v5Hws-8hk4Kc3t_NXn8IoY4ZYVdc86z2QRba2CmsdOmEA-8eHxrfsyZHFWrEEdKZyHYvxjqukUFLs50Fy6pCfDvrjyNBjAtl1dnf9Nj5Jm0ul9fPQvmPAMvweio7eiPSwgqK0N4okhCeWhmc0VioXa6KngF81ywVKwm6ZuPBvP1fLlkT3IQ2e3Psy08_qy2cz2cV67Je242GGYfnOaLZl36LyWV0_AUCtjW19KlUsTGIMGopDMEWZDYstyLga9H5O6w7Q58QVg7y2k7-oNLsIMr3nPFiMjZeJGYJZ9dd4PzYa90eT6KAqaGs50nZXt6xwOFEcYsIJjRbn__m_9iA"

# Check if Firefox is installed
if ! command -v firefox &> /dev/null; then
    echo "Error: Firefox is not installed"
    exit 1
fi

# Create Firefox profiles
echo "Creating Firefox profiles..."
firefox -CreateProfile "luis" 2>/dev/null || true
firefox -CreateProfile "work" 2>/dev/null || true
echo "Profiles 'luis' and 'work' created."
echo ""

# Install extensions via policies.json
echo "Setting up Firefox extensions (uBlock Origin, Dark Reader)..."

POLICY_DIR="/usr/lib/firefox/distribution"
POLICY_FILE="$POLICY_DIR/policies.json"

# Create policies.json for auto-installing extensions
sudo mkdir -p "$POLICY_DIR"
sudo tee "$POLICY_FILE" > /dev/null << 'EOF'
{
  "policies": {
    "ExtensionSettings": {
      "uBlock0@raymondhill.net": {
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi",
        "installation_mode": "force_installed"
      },
      "addon@darkreader.org": {
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi",
        "installation_mode": "force_installed"
      }
    }
  }
}
EOF

echo "Extensions configured."
echo ""

# Launch each profile briefly to trigger extension installation
echo "Installing extensions in all profiles..."
for profile in "luis" "work"; do
    echo "  Installing extensions in '$profile' profile..."
    timeout 10 firefox -P "$profile" --headless 2>/dev/null || true
done

echo ""
echo "Opening Firefox to apply Catppuccin Mocha Blue theme..."
echo "Click 'Install' when prompted for Firefox Color extension."
echo ""

# Open Firefox with the theme URL
firefox "$THEME_URL" &

echo "Done!"
