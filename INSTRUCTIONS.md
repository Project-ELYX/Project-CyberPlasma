📐 Instructions for Codex (EWW integration)
Command mode

Spawn panels: Terminal, Filesystem, CPU, MEM, Vitals, Net, Globe, Media, Visualizer.

Each panel is an EWW window with:

background = the skinned SVG frame (.svg file).

overlays = text/icons injected into the content-safe slots (IDs in the SVGs).

Positioning: anchor windows by absolute x/y, sized to the viewBox dims.

CPU/MEM left column, Net/Globe right, Media bottom, Terminal center.

Interaction:

Only Filesystem rows, Terminal tabs, and Media buttons take clicks.

All other panels = click-through true.

Dock/strip hidden.

Optional side rail: only in Command if user enables.

Control mode

Spawn unified strip: control_strip_skinned.svg at top or bottom.

Fill slot-pins with pinned app icons.

Fill slot-net with iface + VPN/IP glyphs.

Fill slot-viz with small GLava or EWW polyline.

Fill slot-media with compact media buttons + scrolling title.

Fill slot-sysmini with CPU%, RAM%, Temp micrographs.

Fill slot-time with date/time.

slot-modebadge optional (CMD/CTL toggle glyph).

Optional extra widgets: CPU/MEM/Vitals/Globe panels can be spawned on desktop if user wants them outside the strip.

Dock hidden (the strip replaces it).

Terminal/Filesystem panels: not persistent, only pop up via hotkey.

General EWW usage

Theme control: SCSS maps .cp-chrome, .cp-accent, .cp-accent2, .cp-text, .cp-muted, .cp-ok/warn/err to palette values.

Dynamic data: small shell scripts output strings/numbers → bound into slots:

CPU bars: loop across nproc count, draw bars in #bar-matrix.

MEM: fill dot matrix in #ram-matrix → # of filled dots = % used.

Vitals: write temps/uptime/load into slot-….

Net: iface, IPs, VPN status, traffic → slot-local/public/up/down.

Media: bind playerctl to button rects, write title to slot-media.

States: apply .cp-ok / warn / err to glyphs for temps, CPU, etc.

🗂️ Mode summary

Command = cockpit grid. All panels locked, strip hidden.

Control = free desktop. Strip visible, panels optional.

🖥 CPU per-core bars (btop style)

Detect core count: use nproc --all (or parse /proc/stat). That’s your N.

Layout:

Grid the bar-matrix safe rect.

Calculate cols and rows. For 16 threads, do 4×4. For 12, 3×4.

Each bar slot:

Draw a rect track (thin outline, cp-chrome @30–40% opacity).

Inside, draw a filled rect (cp-accent) whose height = usage %.

Base aligned to bottom of the slot, so bars “grow up.”

Thread labels:

Reserve the label band under the matrix.

Write 0,1,…N-1 in ShureTechMono Nerd Font, size ~10px, centered under each bar.

State coloring:

Normal = cp-accent.

Warn (>=80%) = cp-warn.

Critical (>=95%) = cp-err.

🔋 Memory (dot matrix)

Dot grid: 24×10 = 240 dots. Each dot = a small filled square or circle.

Order: left→right, top→bottom fill.

Compute used_dots: round(total_dots * (used_mem / total_mem)).

Fill style:

Filled = cp-accent at 80–90% opacity.

Empty = cp-chrome at 30% opacity.

Warn/Err states: tint last 20% filled dots with cp-warn/cp-err.

Swap row: 1×24 dots below, same logic but only drawn if swap_total > 0.

🌡 System vitals

Temps: Show CPU 47°C • GPU 56°C • MB 41°C (format: label value).

Tint glyph with cp-ok / cp-warn / cp-err by thresholds.

Uptime: “3d 4h 12m” format.

Load: show 3 numbers (1m, 5m, 15m).

Power: if laptop → “DC 63%” or “AC.” If desktop → hide battery.

🌐 Network panel

Local/Public IPs: string values in slots.

VPN badge: put VPN glyph in badge seat; overlay text “WG” or “OVPN.”

Traffic sparkline:

Maintain a rolling buffer of last N samples (e.g., 60s).

Draw a polyline across sparkline-safe rect.

Scale Y to max seen in buffer.

Up/Down numbers: current kB/s or MB/s.

🎵 Media panel

Controls: overlay icons (prev/playpause/next) centered in their hit rects.

Play/pause toggle: one slot, swap icon depending on playerctl status.

Title: text in slot-media, ellipsize or scroll if too long.

Progress bar: draw fill rect inside #progress whose width = position / length.

🎛 Visualizer

If using GLava: window sits behind viz-window.

Or: draw simple EWW polyline inside the safe rect.

⚙️ Implementation notes for Codex

All fills should respect cp-accent/warn/err classes for dynamic recolor.

Text always in ShureTechMono Nerd Font.

Everything drawn inside the slot-* rects, sized to fit.

Use EWW loops for dynamic elements (e.g., for i in (seq 0 (nproc-1)) for CPU bars).

CPU/MEM update at 1 Hz.

Vitals/Net update at 3–5s.

Media update at 500–1000ms.