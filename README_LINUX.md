# Tekken 6 Native Online - Linux Guide (Manjaro / Arch / SteamOS)

This package contains the native PC recompiled version of **Tekken 6 (Xbox 360)** with rollback netcode (GGPO) and online matchmaking, adapted for Linux (tested and verified on Manjaro Linux / Arch Linux).

---

## Requirements

1. **Vulkan Drivers**:
   - AMD: `sudo pacman -S vulkan-radeon lib32-vulkan-radeon`
   - Intel: `sudo pacman -S vulkan-intel lib32-vulkan-intel`
   - NVIDIA: `sudo pacman -S nvidia-utils lib32-nvidia-utils`
2. **Compatibility Runner**:
   - **Steam with Proton** (Recommended): Ensure Steam is installed with Proton Experimental or Proton 9.0.
   - *Or* **System Wine**: `sudo pacman -S wine wine-gecko wine-mono vkd3d`
3. **Tekken 6 Xbox 360 Disc Copy**:
   - An `.iso` or extracted folder of: **Tekken 6 (USA, Europe), Rev 1** (Xbox 360).
   - About 10 GB of free disk space.

---

## Quick Start

1. Extract `tekken6_native_online.zip` into a directory (e.g. `~/Games/Tekken6NativeOnline`).
2. Run the Linux setup helper (optional, creates desktop shortcut):
   ```bash
   ./setup_linux.sh
   ```
3. Start the launcher:
   ```bash
   ./Tekken6NativeOnline.sh
   ```
   *(Or launch "Tekken 6 Native Online" from your desktop Application Menu)*
4. In the launcher, go to **Profile -> BUILD GAME**, select your Tekken 6 `.iso` (or extracted disc folder), and click Start.
5. The builder will extract the game data, translate `Default.xex` to C++, apply the netplay patches, and compile `tekken6.exe`.
6. Once completed, you can play practice mode or jump into online matchmaking!

---

## What was Changed for Linux Support

1. **ICU UC & IN Libraries (`icuuc.dll`, `icuin.dll`)**:
   - Qt6 MSVC builds expect Windows 10's built-in ICU libraries (`icuuc.dll`), which are not present in standard Wine/Proton prefixes. These are now bundled so Qt 6 boots properly without missing DLL errors.
2. **Cross-Platform Builder (`builder/build_native.py`)**:
   - Added CPU feature detection via `/proc/cpuinfo` for AVX2 and FMA3 on Linux so that float instructions match the online player base.
   - Added automatic Wine/Proton binary wrapping for `xdvdfs.exe`, `rexglue.exe`, and `clang++.exe` when building.
3. **Linux Runner Script (`Tekken6NativeOnline.sh`)**:
   - Automatically discovers Proton installations from Steam (`Proton - Experimental`, `Proton 9.0 (Beta)`, `Proton Hotfix`) or system Wine.
   - Sets low-latency netplay parameters (`WINEFSYNC=1`, `PULSE_LATENCY_MSEC=30`, `VKD3D_CONFIG=dxr11,dxr`).
4. **Desktop Integration**:
   - Included `app.png` and `setup_linux.sh` to install a `.desktop` shortcut into the system application menu.

---

## Controller Setup

- **Steam Input**: If running alongside Steam, Xbox 360 / Xbox One / PlayStation 4 & 5 controllers work natively through SDL3.
- **MMJoystick / DirectInput**: Custom mappings can be configured in `tools/mmjoystick.ini`.
- Controllers can also be configured directly in the launcher under **Controls**.
