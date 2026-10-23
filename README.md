# Tekken 6 Native Online (Xbox 360) - Windows & Linux

Tekken 6 for Xbox 360 running natively on PC (Windows & Linux, recompiled, no emulator) with rollback netcode (GGPO principle) and
an online lobby in the launcher.

Found a bug? Please report it (see **Bug reports** below).

Download: see **Releases** (`tekken6_native_online.zip` or `tekken6_native_online_linux.zip`). The package contains **no part of the game**. You build the
game yourself from **your own copy** of Tekken 6 for Xbox 360 (a disc image `.iso`). Both players must use the same
version of the package.

## Requirements

### Windows
- Windows 10 or 11, 64-bit
- A graphics card with DirectX 12
- Your own Tekken 6 for Xbox 360 disc image: **Tekken 6 (USA, Europe), Rev 1** (`.iso`, or the extracted disc folder).
  Other versions are refused by the builder.
- About 10 GB of free disk space (game data 6.7 GB + the build)

### Linux (Manjaro / Arch / SteamOS / Ubuntu)
- 64-bit Linux distribution with Vulkan drivers installed:
  - **AMD**: `vulkan-radeon lib32-vulkan-radeon`
  - **Intel**: `vulkan-intel lib32-vulkan-intel`
  - **NVIDIA**: `nvidia-utils lib32-nvidia-utils`
- **Compatibility Runner**:
  - **Steam with Proton** (Recommended): Proton Experimental, Proton 9, or Proton Hotfix.
  - *or* **Wine**: `wine wine-gecko wine-mono vkd3d`
- Your own Tekken 6 for Xbox 360 disc image: **Tekken 6 (USA, Europe), Rev 1** (`.iso`, or the extracted disc folder).
- About 10 GB of free disk space.

## Installation

### On Linux (Manjaro / Arch):
1. Extract the release package zip (`tekken6_native_online.zip` or `tekken6_native_online_linux.zip`).
2. Run the Linux setup helper (sets permissions, checks Vulkan/Proton, and adds desktop shortcut):
   ```bash
   ./setup_linux.sh
   ```
3. Start the launcher:
   ```bash
   ./Tekken6NativeOnline.sh
   ```
   *(Or click "Tekken 6 Native Online" from your desktop Application Menu)*
4. In the launcher, go to **Profile -> BUILD GAME**, select your Tekken 6 `.iso` (or extracted disc folder), and click Start.
5. The builder translates and compiles the game automatically on your machine (3-10 minutes).
6. Done! The launcher connects to the online lobbies and starts the game seamlessly.

### On Windows:
1. Extract `tekken6_native_online.zip` into its own folder (not into Program Files).
2. If Windows reports missing Visual C++ files, run `vc_redist.x64.exe` from the folder.
3. Start `Tekken6 Native Online.exe`.
4. In the launcher open **Profile -> BUILD GAME**, pick your Tekken 6 `.iso` and start the build.
5. Done. The launcher uses the built game automatically.

## Playing

Log in (or play as a guest), find an opponent in the lobby and play. The game starts directly in the fight; it stays
open between matches. Matches are first to 3 rounds. A stable connection matters (cable is better than Wi-Fi).

## Updating

The launcher looks for new versions and updates itself with one click. After an update that changes the
game code, the launcher asks you to build the game again (your game data is kept).

## Bug reports

Please send the files from the package folder: `native\build.log` (build problems) and the newest log of the game.

## Source code

The source code is open: [Ekspym/tekken6-native-online-source](https://github.com/Ekspym/tekken6-native-online-source).
It is published there without the full development history, because I don't want every work-in-progress commit to be
public. Every patch released here is also added there as one commit, so the source always matches the latest release.

## Credits

Big thanks to **mahmoud-mess** for [tekken6-recomp](https://github.com/mahmoud-mess/tekken6-recomp) - his Tekken 6
recompilation work gave this project faster recompiled code. Thank you!
