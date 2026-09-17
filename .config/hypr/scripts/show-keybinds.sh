#!/usr/bin/env bash
# Pulls live bind descriptions from Hyprland and shows them in wofi.
hyprctl binds -j | jq -r '
  def modnames:
    ( (if (. % 2)       >= 1 then ["SHIFT"] else [] end)
    + (if ((./4)  | floor % 2) >= 1 then ["CTRL"]  else [] end)
    + (if ((./8)  | floor % 2) >= 1 then ["ALT"]   else [] end)
    + (if ((./64) | floor % 2) >= 1 then ["SUPER"] else [] end)
    );
  .[] | select(.description != "") |
  ((.modmask | modnames) + [.key] | join(" + ")) + "  →  " + .description
' | wofi --dmenu --prompt "Keybinds" --width 700 --height 600 --cache-file /dev/null
