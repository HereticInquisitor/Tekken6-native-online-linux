#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "=========================================================="
echo " Tekken 6 Native Online - Linux / Manjaro Setup"
echo "=========================================================="

chmod +x "$DIR/Tekken6NativeOnline.sh"

# Check Vulkan drivers
echo "[1/4] Checking Vulkan support..."
if command -v vulkaninfo >/dev/null 2>&1; then
    echo "  Vulkan is available."
else
    echo "  Tip: If you encounter graphics issues, install Vulkan drivers for your GPU:"
    echo "       AMD:    sudo pacman -S vulkan-radeon lib32-vulkan-radeon"
    echo "       Intel:  sudo pacman -S vulkan-intel lib32-vulkan-intel"
    echo "       NVIDIA: sudo pacman -S nvidia-utils lib32-nvidia-utils"
fi

# Check Wine / Proton
echo "[2/4] Checking Proton / Wine compatibility layer..."
FOUND_RUNNER=""
for p in \
    "$HOME/.local/share/Steam/steamapps/common/Proton - Experimental/proton" \
    "$HOME/.local/share/Steam/steamapps/common/Proton 9.0 (Beta)/proton" \
    "$HOME/.local/share/Steam/steamapps/common/Proton Hotfix/proton" \
    "$HOME/.steam/steam/steamapps/common/Proton - Experimental/proton"; do
    if [ -x "$p" ]; then
        FOUND_RUNNER="$p"
        echo "  Found Steam Proton: $p"
        break
    fi
done

if [ -z "$FOUND_RUNNER" ]; then
    if command -v wine >/dev/null 2>&1; then
        echo "  Found system Wine: $(wine --version)"
    else
        echo "  Warning: Neither Steam Proton nor system Wine was found!"
        echo "  Recommended for Manjaro/Arch: Install Steam, or install Wine:"
        echo "    sudo pacman -S wine wine-gecko wine-mono vkd3d"
    fi
fi

# Ensure ICU DLLs are present
echo "[3/4] Ensuring ICU compatibility DLLs..."
if [ -f "$DIR/icuuc.dll" ] && [ -f "$DIR/icuin.dll" ]; then
    echo "  ICU DLLs are present."
else
    ./Tekken6NativeOnline.sh --check-icu-only || true
fi

# Desktop shortcut
echo "[4/4] Installing desktop entry..."
APPS_DIR="$HOME/.local/share/applications"
mkdir -p "$APPS_DIR"
DESKTOP_FILE="$APPS_DIR/Tekken6NativeOnline.desktop"

cat << DESKTOP_EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=Tekken 6 Native Online
Comment=Tekken 6 Xbox 360 PC Recompilation with Rollback Netcode
Exec="$DIR/Tekken6NativeOnline.sh"
Path=$DIR
Icon=$DIR/app.png
Terminal=false
Type=Application
Categories=Game;ActionGame;
StartupNotify=true
DESKTOP_EOF

chmod +x "$DESKTOP_FILE"
echo "  Desktop entry created at: $DESKTOP_FILE"

echo "=========================================================="
echo " Setup complete! You can now launch Tekken 6 Native Online:"
echo "   1. From your Application Menu (search 'Tekken 6 Native Online')"
echo "   2. By running: ./Tekken6NativeOnline.sh"
echo "=========================================================="
