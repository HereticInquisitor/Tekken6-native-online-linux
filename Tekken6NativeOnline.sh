#!/usr/bin/env bash
set -e

# Tekken 6 Native Online - Linux / Manjaro / Arch Runner
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 1. Ensure ICU DLLs exist so Qt6Core loads properly
if [ ! -f "$SCRIPT_DIR/icuuc.dll" ] || [ ! -f "$SCRIPT_DIR/icuin.dll" ]; then
    echo "[Tekken6 Linux] Checking for ICU DLLs..."
    FOUND_ICU=""
    # Check Steam Proton installations
    for d in \
        "$HOME/.local/share/Steam/steamapps/common/Proton - Experimental/files/lib/wine/x86_64-windows" \
        "$HOME/.local/share/Steam/steamapps/common/Proton 9.0 (Beta)/files/lib64/wine/x86_64-windows" \
        "$HOME/.local/share/Steam/steamapps/common/Proton Hotfix/files/lib/wine/x86_64-windows" \
        "$HOME/.steam/steam/steamapps/common/Proton - Experimental/files/lib/wine/x86_64-windows" \
        "/usr/lib/wine/x86_64-windows"; do
        if [ -f "$d/icu.dll" ]; then
            FOUND_ICU="$d/icu.dll"
            break
        fi
    done

    if [ -n "$FOUND_ICU" ]; then
        echo "[Tekken6 Linux] Installing ICU DLLs from $FOUND_ICU..."
        cp "$FOUND_ICU" "$SCRIPT_DIR/icuuc.dll"
        cp "$FOUND_ICU" "$SCRIPT_DIR/icuin.dll"
    else
        echo "[Tekken6 Linux] Warning: icu.dll not found automatically. If Qt6 fails to start, install wine or steam."
    fi
fi

# 2. Locate Proton or Wine
RUNNER=""
RUNNER_TYPE=""

# Check for Steam Proton first (Proton has VKD3D-Proton built-in which is ideal for D3D12)
PROTON_CANDIDATES=(
    "$HOME/.local/share/Steam/steamapps/common/Proton - Experimental/proton"
    "$HOME/.local/share/Steam/steamapps/common/Proton 9.0 (Beta)/proton"
    "$HOME/.local/share/Steam/steamapps/common/Proton Hotfix/proton"
    "$HOME/.steam/steam/steamapps/common/Proton - Experimental/proton"
)

for p in "${PROTON_CANDIDATES[@]}"; do
    if [ -x "$p" ]; then
        RUNNER="$p"
        RUNNER_TYPE="proton"
        break
    fi
done

# If no Proton found, fallback to system wine
if [ -z "$RUNNER" ]; then
    if command -v wine >/dev/null 2>&1; then
        RUNNER="wine"
        RUNNER_TYPE="wine"
    fi
fi

if [ -z "$RUNNER" ]; then
    echo "ERROR: Neither Proton (via Steam) nor Wine was found!"
    echo "Please ensure Steam with Proton is installed, or install wine: sudo pacman -S wine wine-gecko wine-mono"
    exit 1
fi

echo "[Tekken6 Linux] Using $RUNNER_TYPE: $RUNNER"

# 3. Setup Wine Prefix & Overrides
PFX_DIR="$HOME/.local/share/tekken6_native_online/pfx"
mkdir -p "$PFX_DIR"

# Performance & Netplay environment variables
export WINEFSYNC=1
export WINEESYNC=1
export PULSE_LATENCY_MSEC=30
export WINEDEBUG=-all
export VKD3D_CONFIG=dxr11,dxr
export WINEDLLOVERRIDES="mscms=d;${WINEDLLOVERRIDES:-}"

# Ensure mscms is disabled in registry to prevent unimplemented WcsCreateIccProfile abort
if [ -f "$PFX_DIR/user.reg" ]; then
    if ! grep -q '"mscms"=""' "$PFX_DIR/user.reg" 2>/dev/null; then
        printf '\n[Software\\\\Wine\\\\DllOverrides]\n"mscms"=""\n' >> "$PFX_DIR/user.reg"
    fi
fi

# 4. Launch
if [ "$RUNNER_TYPE" = "proton" ]; then
    export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.local/share/Steam"
    export STEAM_COMPAT_DATA_PATH="$HOME/.local/share/tekken6_native_online"
    exec "$RUNNER" run "$SCRIPT_DIR/Tekken6 Native Online.exe" "$@"
else
    export WINEPREFIX="$PFX_DIR"
    exec "$RUNNER" "$SCRIPT_DIR/Tekken6 Native Online.exe" "$@"
fi
