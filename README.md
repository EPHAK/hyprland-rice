# hyprland-rice

Hyprland desktop configuration for Arch Linux. Catppuccin Mocha color scheme, Lua-based Hyprland config (0.56+), managed with chezmoi.

![screenshot](.github/screenshot.png)

## Stack

| Role | Tool |
|---|---|
| Compositor | [Hyprland](https://hyprland.org) |
| Bar | [waybar](https://github.com/Alexays/Waybar) |
| Launcher | [wofi](https://sr.ht/~scoopta/wofi/) |
| Terminal | [kitty](https://sw.kovidgoyal.net/kitty/) |
| Notifications | [swaync](https://github.com/ErikReider/SwayNotificationCenter) |
| Window switcher | [hyprshell](https://github.com/H3rmt/hyprshell) |
| Lock / idle | hyprlock, hypridle |
| Wallpaper daemon | [awww](https://codeberg.org/LGFae/awww) (successor to swww) |
| Wallpaper picker | [waypaper](https://github.com/anufrievroman/waypaper) |
| Power menu | [wlogout](https://github.com/ArtsyMacaw/wlogout) |
| OSD | [swayosd](https://github.com/ErikReider/SwayOSD) |
| Screenshot annotation | [satty](https://github.com/gabm/satty) |
| Clipboard history | [cliphist](https://github.com/sentriz/cliphist) |
| Editor | [Neovim](https://neovim.io), [lazy.nvim](https://github.com/folke/lazy.nvim), LSP via [mason.nvim](https://github.com/williamboman/mason.nvim), Catppuccin Mocha |
| File manager (TUI) | [yazi](https://yazi-rs.github.io) |
| System monitor | [btop](https://github.com/aristocratos/btop) |
| Audio visualizer | [cava](https://github.com/karlstav/cava) |
| Keybind browser/editor | [keybey](https://github.com/EPHAK/keybey) (private, not part of this repo) |
| Bluetooth manager (TUI) | [bt-tui](https://github.com/EPHAK/bt-tui) (not part of this repo) |
| Equalizer (TUI) | [eqt](https://github.com/EPHAK/eqt) (not part of this repo) |
| Settings panel | GNOME Control Center |
| Dotfile management | [chezmoi](https://www.chezmoi.io) |

## Notes on specific components

- **swaync** is configured with `title`, `dnd`, `mpris`, `calendar`, and `notifications` widgets, so the panel covers do-not-disturb, media control, and a calendar in addition to notifications.
- **waybar** modules use explicit text labels (`CPU`, `RAM`, `VOL`, `BAT`, `WiFi`) rather than bare icon+percentage. Several modules have `on-click-right` bound to the relevant settings panel or tool (e.g. the battery module opens the power settings panel, CPU/RAM open `gnome-system-monitor`).
- **hyprshell** replaces Hyprland's default focus-cycling Alt-Tab with a windowed switcher (config in `.config/hyprshell/config.ron`).
- Window minimize/restore (`SUPER+H` / `SUPER+SHIFT+H`) is implemented via special workspaces, since Wayland has no native minimize concept. Each minimized window gets its own uniquely-named special workspace (derived from its address) rather than sharing one. A shared workspace means revealing any minimized window (e.g. via Alt-Tab) reveals all of them at once, since a special workspace has no per-window visibility control.
- Animation curves use an expo-out bezier (`{0.16, 1}, {0.3, 1}`) instead of Hyprland's default, to avoid overshoot/bounce.
- Screenshot binds pipe `grim`/`slurp` output into `satty` for annotation before saving/copying, except `SUPER + Print`, which calls `grim` directly for an instant, unannotated capture. Its filename uses shell `$(date +...)` substitution, not `grim`'s own filename argument -- this `grim` build doesn't expand `strftime` patterns there, so a naive `%Y%m%d-%H%M%S.png` argument produces a literal filename instead of a timestamp.
- `SUPER + SHIFT + /` opens [keybey](https://github.com/EPHAK/keybey) (alias `kb`), a separate keybind browser/editor covering this Lua config *and* yazi's keymap together -- not part of this repo, install it independently if you want that bind to resolve to anything.
- `mimeapps.list` sets [Loupe](https://apps.gnome.org/Loupe/) as the default handler for image mimetypes. Without it, `xdg-open`/GTK file managers may fall through to a browser (observed: Chrome claiming `image/png` with no `~/.config/mimeapps.list` present to override it).
- `kitty.conf` maps `Ctrl+Plus`/`Ctrl+Minus`/`Ctrl+0` to `change_font_size`, matching the convention most browsers use for page zoom.
- `waypaper` is configured with `subfolders`/`all_subfolders` enabled, so selecting `~/Pictures` also surfaces `Pictures/wallpapers` without switching folders manually.
- Wallpaper backend is `awww`, not `hyprpaper`. waypaper's hyprpaper integration calls `hyprctl hyprpaper unload all` then reloads with no `fit_mode` on every switch, silently discarding any fit/crop config on each change (a waypaper bug, not a hyprpaper config issue; confirmed by reading waypaper's own `change_with_hyprpaper()` source). `awww` applies `--resize fit` on every single call instead, with no such reset.
- **Neovim** setup notes, since the plugin ecosystem has had breaking rewrites that a lot of still-circulating tutorials/configs don't reflect: `nvim-treesitter` is pinned to its `main` branch (the actively maintained one; `master` was archived over a year ago) and uses that branch's newer, minimal API (parser install only; highlighting/indent/folding wired up separately in `lua/plugins/treesitter.lua`, exactly as its current README documents). LSP uses Neovim 0.11+'s native `vim.lsp.config()`/`vim.lsp.enable()` (`mason-lspconfig`'s old `setup_handlers()` API was removed). Requires `tree-sitter-cli` (a C compiler alone isn't enough; some parsers build via the CLI) and Mason's own LSP servers need network on first launch (`ensure_installed` in `lua/plugins/lsp.lua`, skipped automatically when Neovim runs `--headless`; this is intentional upstream behavior, not a bug, and only fires on a normal interactive launch).

## Keybindings

`SUPER` = Super/Windows key.

| Bind | Action |
|---|---|
| `SUPER + Return` / `SUPER + T` | Open terminal |
| `SUPER + R` | Open launcher |
| `SUPER + E` | Open file manager |
| `SUPER + I` | Open settings |
| `SUPER + W` | Wallpaper switcher |
| `SUPER + D` | Display settings (nwg-displays) |
| `SUPER + C` / `XF86Calculator` | Open calculator |
| `SUPER + L` | Lock screen |
| `SUPER + /` | List keybinds (reads live from `hyprctl binds`) |
| `SUPER + SHIFT + /` | Keybind cheatsheet, live-searchable (opens `kb --search`) |
| `SUPER + SHIFT + E` | Power menu |
| `SUPER + SHIFT + V` | Clipboard history |
| `CTRL + W` | Close tab/window (handled by the app, not a global bind) |
| `SUPER + Q` | Close active window |
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
| `ALT + Tab` (hold) | Window switcher |
| `Super_L` (tap) | Overview/launcher |
| `Print` / `SHIFT + Print` | Screenshot region/fullscreen, opens in satty |
| `SUPER + Print` | Instant full-screen screenshot, no annotate step |
| `SUPER + SHIFT + R` | Toggle screen recording |
| Volume / brightness keys | OSD via swayosd |

## Known issues (Hyprland/SDDM)

Two real, confirmed-reproducible bugs, not specific to this config, that
this rice works around. Documented here mainly so it's clear these are
known and already handled, not something to re-debug from scratch.

- **`start-hyprland` crashes on session exit** (Hyprland 0.56.2's own
  session-launcher wrapper). Root cause, confirmed by reading its actual
  source (`start/src/core/Instance.cpp`, `start/src/main.cpp` in
  hyprwm/Hyprland): its SIGTERM handler calls `forceQuit()` →
  `m_hlThread.join()`, while the normal exit path in `run()` *also*
  calls `m_hlThread.join()` on the same thread. systemd-logind SIGTERMs
  the entire session scope (including `start-hyprland` itself) the
  instant any graphical session ends, for any reason -- so both join
  paths fire almost every time, double-joining the same `std::thread`,
  which throws an unhandled `std::system_error` and aborts (confirmed
  via `coredumpctl` -- identical stack trace, reproduced multiple
  times). This crashed (not graceful) session-leader death is what
  breaks the next part.
  **Workaround** (`system/wayland-sessions/hyprland.desktop`, installed
  to `/usr/local/share/wayland-sessions/`, which SDDM checks before
  `/usr/share/wayland-sessions/`): launch `/usr/bin/Hyprland` directly,
  bypassing the wrapper entirely. `--watchdog-fd` (the wrapper's own
  arg to Hyprland) is documented as wrapper-only, not required.
- **SDDM's greeter doesn't reliably come back after a Wayland session
  ends** -- known, still-open upstream bug
  ([sddm/sddm#1984](https://github.com/sddm/sddm/issues/1984)), not
  fixed even with the above workaround in place: a dead screen with a
  bare cursor, no greeter, requiring a manual TTY login otherwise.
  **Workaround** (`system/sddm-watchdog/`): a systemd timer polls every
  5s; if `sddm.service` is active but neither a Hyprland process nor a
  greeter process is running, it restarts `sddm.service`, which does
  reliably bring the greeter back every time this was tested manually.
- **`hyprctl dispatch exit` (plain string) is a silent no-op** on this
  Hyprland 0.56 Lua-config build -- the CLI `dispatch` subcommand wraps
  its argument as `hl.dispatch(<arg>)`, which needs an actual Lua
  dispatcher value, not a bare string; it errors internally and does
  nothing, no crash, no exit. The correct form, used by `wlogout`'s
  Logout action and equivalent to what `SUPER+SHIFT+Q`'s `hl.dsp.exit()`
  bind does: `hyprctl dispatch 'hl.dsp.exit()'`.
- **Hyprland crashes (SIGSEGV) on essentially every real exit**, clean
  or not -- confirmed via `coredumpctl`: `CDRMBackend::flushAsyncCommitEvents`
  in `libaquamarine`, called from its destructor chain during a normal
  `exit()`. Most likely an NVIDIA/hybrid-GPU DRM-teardown issue in
  Aquamarine (Hyprland's backend library), not something fixable from
  this config -- affects `SUPER+SHIFT+Q` too, not just `wlogout`. Left
  as-is: the two workarounds above mean this now self-heals in a few
  seconds instead of requiring a manual TTY.

Install steps for both workarounds are in the main **Install** section
below (step 5); they're system-level files, outside the
chezmoi-applied `~/.config` tree.

## Install

This repo mirrors `~/.config` (plus `wallpapers/` and `system/`) and is kept in sync by hand with the actual machine, as a public, browsable copy of the setup. It is **not** what `chezmoi apply` uses on the real machine; that's a separate, private `dotfiles` repo (same content, kept in sync). This one exists to be public and readable, not to be applied directly. Not written as a generic installer regardless; check paths/assumptions against your own hardware first, particularly anything GPU- or hardware-specific in `hyprland.lua`.

Full setup, in order:

```bash
# 1. packages (official repos)
sudo pacman -S hyprland waybar wofi kitty swaync hyprlock hypridle \
  awww waypaper wlogout swayosd satty cliphist wl-clipboard \
  gnome-control-center nwg-displays gnome-calculator loupe \
  gnome-system-monitor baobab \
  yazi fd ripgrep zoxide 7zip poppler jq python-tomlkit \
  btop cava fastfetch \
  neovim tree-sitter tree-sitter-cli nodejs npm python-pynvim luarocks unzip \
  ttf-jetbrains-mono-nerd weston qt5-quickcontrols2

# 2. hyprshell (AUR)
yay -S hyprshell-bin

# 3. configs
cp -r .config/* ~/.config/

# 4. wallpapers -- referenced by absolute path in hyprlock.conf,
#    waypaper's config, and the SDDM theme, so they need to land here
mkdir -p ~/Pictures/wallpapers
cp wallpapers/* ~/Pictures/wallpapers/

# 5. system-level files (session-launcher fix, SDDM crash watchdog) --
#    see system/README.md for what these do and why
sudo install -m644 system/wayland-sessions/hyprland.desktop /usr/local/share/wayland-sessions/hyprland.desktop
sudo install -m755 system/sddm-watchdog/sddm-watchdog.sh /usr/local/bin/sddm-watchdog.sh
sudo install -m644 system/sddm-watchdog/sddm-watchdog.service /etc/systemd/system/sddm-watchdog.service
sudo install -m644 system/sddm-watchdog/sddm-watchdog.timer /etc/systemd/system/sddm-watchdog.timer
sudo systemctl daemon-reload
sudo systemctl enable --now sddm-watchdog.timer

# 6. SDDM login-screen theme -- see system/sddm-theme/README.md,
#    it's a multi-step AUR + manual-patch process, not a straight copy

# 7. neovim plugins + LSP servers -- lazy.nvim bootstraps itself on first
#    launch. Headless sync (plugins only; treesitter parsers pull further
#    dependencies on first real file open, and Mason's ensure_installed is
#    intentionally skipped in --headless mode -- see Notes above):
nvim --headless "+Lazy! sync" +qa
```

`keybey` (the keybind browser/editor `SUPER+SHIFT+/` opens) is a
separate public repo: [github.com/EPHAK/keybey](https://github.com/EPHAK/keybey).
`bt-tui` and `eqt` are public and installable independently the same
way as any of these tools.

## License

[MIT](LICENSE)
