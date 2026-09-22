SDDM login screen theme, tracked here for reference/backup only (same
reasoning as the parent `system/` dir -- these live outside `~/.config`
and outside chezmoi's reach).

## Setup from scratch

1. Install the theme (AUR, so needs an AUR helper -- `yay` here):

   ```bash
   yay -S catppuccin-sddm-theme-mocha
   ```

   This installs all 14 accent variants under
   `/usr/share/sddm/themes/catppuccin-mocha-<accent>/`. This rice uses
   the `red` accent.

2. Install `weston` (the theme's greeter compositor) and Qt5's
   QtQuick.Controls (the installed `sddm` binary here links Qt5, not
   Qt6 -- the AUR package's own dependency list doesn't always pull
   this in):

   ```bash
   sudo pacman -S weston qt5-quickcontrols2
   ```

3. Point SDDM at the theme:

   ```bash
   sudo cp sddm.conf.d-theme.conf /etc/sddm.conf.d/theme.conf
   ```

4. Copy the wallpaper into the theme's own directory (it ships its own
   `wall.png`; this rice overrides it) and patch the theme's font +
   background:

   ```bash
   sudo cp ../../wallpapers/cyberpunk-night.png /usr/share/sddm/themes/catppuccin-mocha-red/backgrounds/cyberpunk-night.png
   sudo cp catppuccin-mocha-red-theme.conf /usr/share/sddm/themes/catppuccin-mocha-red/theme.conf
   ```

5. Restart SDDM to pick it up:

   ```bash
   sudo systemctl restart sddm
   ```

## Files here

- `sddm.conf.d-theme.conf` → `/etc/sddm.conf.d/theme.conf`. Selects the
  `catppuccin-mocha-red` theme and sets `DisplayServer=wayland`.
- `catppuccin-mocha-red-theme.conf` → the theme package's own
  `theme.conf`, patched from its shipped default: `Font` set to
  `JetBrains Mono`, `Background` pointed at `cyberpunk-night.png`
  instead of the theme's stock `wall.png`.

## Why `weston`, why Qt5

SDDM's Wayland greeter needs its own compositor to run in
(`CompositorCommand=weston --shell=kiosk`, set by SDDM's own default
config, not something this theme or rice changes). Separately, the
`sddm` binary on this system (`sddm` 0.21.0, Arch `extra`) links Qt5
(`libQt5Qml.so.5`), confirmed via `ldd /usr/bin/sddm-greeter` --
despite the greeter QML using `QtQuick.Controls`, which needs the Qt5
build of that module (`qt5-quickcontrols2`) explicitly installed, since
the AUR theme package's dependency list assumes it's already present.
Without it: `module "QtQuick.Controls" is not installed`, greeter fails
to render.
