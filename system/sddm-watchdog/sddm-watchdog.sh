#!/bin/bash
# Restarts sddm.service if neither a real user session (Hyprland) nor a
# greeter is running while sddm.service itself is active -- covers the
# known, still-open upstream SDDM bug (sddm/sddm#1984) where the greeter
# doesn't reliably come back after a Wayland session ends.

pgrep -x Hyprland >/dev/null && exit 0
pgrep -f "sddm-greeter" >/dev/null && exit 0
systemctl is-active --quiet sddm || exit 0

logger -t sddm-watchdog "No Hyprland session or greeter detected while sddm is active -- restarting sddm"
systemctl restart sddm
