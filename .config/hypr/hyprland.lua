-- Hyprland 0.56+ Lua config.
-- Migrated from the old hyprland.conf (INI) format, which is no longer
-- parsed correctly by this Hyprland version. See ~/hyprland.conf.old-bak
-- for the previous version if you need to cross-reference anything.

local mainMod = "SUPER"
local terminal = "kitty"
local launcher = "wofi --show drun"

-- ============================================================
-- Environment / monitor
-- ============================================================

hl.env("XCURSOR_SIZE", "24")

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- ============================================================
-- Autostart
-- ============================================================

hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
	hl.exec_cmd("swaync")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
	hl.exec_cmd("nm-applet --indicator")
	-- Backends for gnome-control-center panels (mouse, power, keyboard, sound, etc.)
	hl.exec_cmd("/usr/lib/gsd-xsettings")
	hl.exec_cmd("/usr/lib/gsd-power")
	hl.exec_cmd("/usr/lib/gsd-color")
	hl.exec_cmd("/usr/lib/gsd-keyboard")
	hl.exec_cmd("/usr/lib/gsd-sound")
	hl.exec_cmd("/usr/lib/gsd-datetime")
	hl.exec_cmd("/usr/lib/gsd-media-keys")
	hl.exec_cmd("swayosd-server")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("gammastep -l geoclue2")
	hl.exec_cmd("blueman-applet")
	hl.exec_cmd("hyprshell run")
end)

-- ============================================================
-- Core config
-- ============================================================

hl.config({
	input = {
		kb_layout = "us",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
		},
	},

	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		["col.active_border"] = { colors = { "rgba(89b4faee)", "rgba(cba6f7ee)" }, angle = 45 },
		["col.inactive_border"] = "rgba(595959aa)",
		layout = "dwindle",
		resize_on_border = true,
	},

	decoration = {
		rounding = 10,
		active_opacity = 1.0,
		inactive_opacity = 0.95,
		blur = {
			enabled = true,
			size = 4,
			passes = 3,
			new_optimizations = true,
			popups = true,
			popups_ignorealpha = 0.6,
		},
		shadow = {
			enabled = true,
			range = 20,
			render_power = 3,
			color = "rgba(00000055)",
			offset = "0 8",
		},
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	misc = {
		disable_hyprland_logo = true,
		force_default_wallpaper = 0,
	},
})

-- ============================================================
-- Animations
-- Curves adapted from a couple of community rices (R7rainz/dotfiles,
-- HyDE) for something snappier/less abrupt than the plain defaults.
-- ============================================================

-- Smooth expo-out: fast start, gentle glide to rest, no bounce/overshoot
hl.curve("smooth", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
-- Same shape but eased in, for closes/exits (accelerates away cleanly)
hl.curve("smoothIn", { type = "bezier", points = { { 0.7, 0 }, { 0.84, 0 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.2, bezier = "smooth", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.8, bezier = "smoothIn", style = "popin 85%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2.2, bezier = "smooth", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "linear" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 5, bezier = "linear" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.5, bezier = "smooth" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5, bezier = "smooth", style = "slide" })
-- These control wofi/swaync pop-in/out
hl.animation({ leaf = "layersIn", enabled = true, speed = 2.2, bezier = "smooth", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.8, bezier = "smoothIn", style = "fade" })

-- ============================================================
-- Gestures (replaces the old gestures { workspace_swipe = true })
-- ============================================================

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- ============================================================
-- Layer rules — blur for waybar / launcher / notifications
-- ============================================================

hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ match = { namespace = "wofi" }, blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "swayosd" }, blur = true })
hl.layer_rule({ match = { namespace = "hyprshell_switch" }, blur = true, ignore_alpha = 0.5 })

-- ============================================================
-- Window rules
-- ============================================================

hl.window_rule({
	match = { class = "^(waypaper)$" },
	float = true,
	center = true,
	size = { 900, 650 },
})

-- ============================================================
-- Binds
-- ============================================================

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal), { description = "[Apps] open terminal" })
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal), { description = "[Apps] open terminal" })
-- Ctrl+W is deliberately NOT bound here: apps (browsers, kitty) handle it
-- natively as "close tab". A global WM-level bind would intercept the key
-- before the app sees it and close the whole window/all tabs instead.
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "[Window] close active window" })
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit(), { description = "[System] exit Hyprland" })
hl.bind(mainMod .. " + V", hl.dsp.window.float(), { description = "[Window] toggle floating" })
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(launcher), { description = "[Apps] open launcher" })
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo(), { description = "[Layout] toggle pseudotile" })
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), { description = "[Layout] toggle split direction" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(), { description = "[Window] toggle fullscreen" })
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"), { description = "[System] lock screen" })
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("env XDG_CURRENT_DESKTOP=GNOME gnome-control-center"), { description = "[System] open settings" })
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/show-keybinds.sh"),
	{ description = "[System] show keybind cheatsheet" })

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }), { description = "[Focus] move left" })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }), { description = "[Focus] move right" })
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }), { description = "[Focus] move up" })
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }), { description = "[Focus] move down" })

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }), { description = "[Window] move left" })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }), { description = "[Window] move right" })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }), { description = "[Window] move up" })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }), { description = "[Window] move down" })

for i = 1, 9 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }), { description = "[Workspace] go to " .. i })
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }),
		{ description = "[Workspace] move window to " .. i })
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }), { description = "[Workspace] go to 10" })
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }), { description = "[Workspace] move window to 10" })

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"), { description = "[Workspace] toggle scratchpad" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }),
	{ description = "[Workspace] move window to scratchpad" })

-- GNOME/Fedora-style minimize: hide the active window, bring it back
-- with SUPER+SHIFT+H. Each minimized window gets its OWN special
-- workspace (named by its address) rather than sharing one -- a shared
-- one meant revealing any minimized window via Alt-Tab revealed ALL of
-- them at once, since a special workspace has no concept of individual
-- window visibility. Per-window workspaces fix that: revealing one
-- window's own special workspace never touches anyone else's.
--
-- Other fixes folded in:
-- - Moving a window INTO a special workspace auto-reveals it as an
--   overlay (confirmed via testing), so it's explicitly toggled closed
--   again right after.
-- - Hyprland's "active window" still points at the just-hidden window
--   afterwards; explicitly focus another window still on the origin
--   workspace instead of relying on focus({last=true}) (unreliable).
local function minimizedWsSuffix(address)
	return "min_" .. address:gsub("^0x", "")
end

hl.bind(mainMod .. " + H", function()
	local w = hl.get_active_window()
	if w == nil then return end
	local suffix = minimizedWsSuffix(w.address)
	local wsName = "special:" .. suffix
	if w.workspace.name == wsName then
		-- Already minimized and its own special workspace is what's
		-- currently revealed (e.g. selected via Alt-Tab) -- just
		-- re-hide it. If it's not actually revealed, there's nothing
		-- to do.
		local activeSpecial = hl.get_active_special_workspace()
		if activeSpecial ~= nil and activeSpecial.name == wsName then
			hl.dispatch(hl.dsp.workspace.toggle_special(suffix))
		end
		return
	end
	local originWs = w.workspace.id
	hl.dispatch(hl.dsp.window.move({ workspace = wsName }))
	hl.dispatch(hl.dsp.workspace.toggle_special(suffix))
	local remaining = hl.get_workspace_windows(originWs)
	if remaining ~= nil then
		for _, rw in ipairs(remaining) do
			if rw.address ~= w.address then
				hl.dispatch(hl.dsp.focus({ window = "address:" .. rw.address }))
				break
			end
		end
	end
end, { description = "[Window] minimize (hide)" })

hl.bind(mainMod .. " + SHIFT + H", function()
	local allWins = hl.get_windows()
	local active = hl.get_active_workspace()
	if allWins == nil or active == nil then return end
	for _, w in ipairs(allWins) do
		if w.workspace.name:match("^special:min_") then
			hl.dispatch(hl.dsp.window.move({ window = "address:" .. w.address, workspace = active.id }))
		end
	end
end, { description = "[Window] restore minimized windows" })

-- GNOME's Displays panel is mutter-specific and does nothing under
-- Hyprland; nwg-displays is the actual working equivalent.
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("nwg-displays"), { description = "[System] display settings" })

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "[Workspace] next" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "[Workspace] previous" })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "[Window] drag move" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "[Window] drag resize" })

local screenshotDir = os.getenv("HOME") .. "/Pictures/Screenshots"
hl.bind("Print", hl.dsp.exec_cmd(
	'mkdir -p ' .. screenshotDir .. ' && grim -g "$(slurp)" - | satty --filename - --output-filename ' ..
	screenshotDir .. '/%Y%m%d-%H%M%S.png --copy-command wl-copy'),
	{ description = "[Screenshot] region, annotate with satty" })
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(
	'mkdir -p ' .. screenshotDir .. ' && grim - | satty --filename - --output-filename ' ..
	screenshotDir .. '/%Y%m%d-%H%M%S.png --copy-command wl-copy'),
	{ description = "[Screenshot] full screen, annotate with satty" })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"), { repeating = true, locked = true })

hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("nautilus"), { description = "[Apps] open file manager" })
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("wlogout"), { description = "[System] power menu" })
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("waypaper"), { description = "[System] wallpaper switcher" })
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/toggle-recording.sh"),
	{ description = "[Screenshot] toggle screen recording" })
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(
	"cliphist list | wofi --dmenu --prompt 'Clipboard' | cliphist decode | wl-copy"),
	{ description = "[System] clipboard history" })
