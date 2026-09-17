# hyprland-rice

A Hyprland (Wayland) desktop setup for Arch Linux — Catppuccin Mocha throughout, built to feel like a complete DE rather than a bare compositor.

![screenshot](.github/screenshot.png)

## Stack

| Role | Tool |
|---|---|
| Compositor | [Hyprland](https://hyprland.org) (Lua config, 0.56+) |
| Bar | [waybar](https://github.com/Alexays/Waybar) |
| Launcher | [wofi](https://sr.ht/~scoopta/wofi/) |
| Terminal | [kitty](https://sw.kovidgoyal.net/kitty/) |
| Notifications / control center | [swaync](https://github.com/ErikReider/SwayNotificationCenter) |
| Window switcher | [hyprshell](https://github.com/H3rmt/hyprshell) |
| Lock / idle / wallpaper | hyprlock, hypridle, hyprpaper |
| Wallpaper picker | [waypaper](https://github.com/anufrievroman/waypaper) |
| Power menu | [wlogout](https://github.com/ArtsyMacaw/wlogout) |
| OSD (volume/brightness) | [swayosd](https://github.com/ErikReider/SwayOSD) |
| Screenshot annotation | [satty](https://github.com/gabm/satty) |
| Clipboard history | [cliphist](https://github.com/sentriz/cliphist) |
| Settings | GNOME Control Center |
| Dotfile management | [chezmoi](https://www.chezmoi.io) |

## Features

- **Notification center, not just popups** — swaync panel has Do Not Disturb, MPRIS media controls (play/pause/skip for whatever's playing), and a calendar widget, not just a notification list.
- **Waybar that's actually readable** — every stat is labeled (CPU/RAM/VOL/BAT/WiFi), not bare icon+percentage. Right-click any of them to jump straight to the relevant settings panel or tool (sound settings, wifi settings, power settings, system monitor, disk usage analyzer).
- **Real Alt-Tab** — hyprshell gives a proper visual window switcher (hold Alt, tap Tab) instead of silent focus-cycling, plus a Super-tap overview/launcher.
- **GNOME-style minimize/restore** — `SUPER+H` hides the active window, `SUPER+SHIFT+H` brings it back, since Wayland has no native minimize.
- **Smooth, fast animations** — expo-out curves, no bouncy overshoot, tuned for feeling snappy rather than showy.
- **Screenshots you can annotate** — region/fullscreen capture pipes straight into satty before saving.
- **Font zoom that matches your browser** — `Ctrl +`/`Ctrl -`/`Ctrl 0` in kitty, same convention as Firefox/Chrome.

## Keybindings

`SUPER` = the Windows/Super key.

| Bind | Action |
|---|---|
| `SUPER + Return` / `SUPER + T` | Open terminal |
| `SUPER + R` | Open launcher |
| `SUPER + E` | Open file manager |
| `SUPER + I` | Open settings |
| `SUPER + W` | Wallpaper switcher |
| `SUPER + L` | Lock screen |
| `SUPER + /` | Show this keybind list (live, pulled from `hyprctl binds`) |
| `SUPER + SHIFT + E` | Power menu |
| `SUPER + SHIFT + V` | Clipboard history |
| `CTRL + W` | Close tab/window (app-native, not a global override) |
| `SUPER + Q` | Force-close active window |
| `SUPER + SHIFT + Q` | Exit Hyprland |
| `SUPER + V` | Toggle floating |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + P` | Toggle pseudotile |
| `SUPER + J` | Toggle split direction |
| `SUPER + arrows` | Move focus |
| `SUPER + SHIFT + arrows` | Move window |
| `SUPER + [1-0]` | Switch workspace |
| `SUPER + SHIFT + [1-0]` | Move window to workspace |
| `SUPER + S` | Toggle scratchpad |
| `SUPER + H` / `SUPER + SHIFT + H` | Minimize / restore window |
| `ALT + Tab` (hold) | Visual window switcher |
| `Super_L` (tap) | Overview / launcher |
| `Print` / `SHIFT + Print` | Screenshot region/fullscreen → annotate → clipboard |
| `SUPER + SHIFT + R` | Toggle screen recording |
| Volume / brightness keys | OSD feedback via swayosd |

## Install

Configs are chezmoi-managed. Adjust paths/hostnames for your own machine before applying — this was built for one specific box, not written as a generic installer.

```bash
chezmoi init --apply <this-repo-url>
```

Or just copy `.config/*` into `~/.config/` directly if you don't use chezmoi.

You'll need (Arch package names): `hyprland waybar wofi kitty swaync hyprshell-bin hyprlock hypridle hyprpaper waypaper wlogout swayosd satty cliphist wl-clipboard gnome-control-center`.

## License

MIT — take whatever's useful, no attribution needed.
