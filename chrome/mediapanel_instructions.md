🎵 CyberPlasma Media Panel — Implementation Instructions
Files

chrome/media_panel_v2.svg → full panel (Command mode).

chrome/media_strip_compact.svg → compact bar version (Control mode).

Control icons: icon-prev.svg, icon-next.svg, icon-play.svg, icon-pause.svg (we already designed these sharp variants).

Command Mode (Panel-size)
Layout

Use media_panel_v2.svg as the frame background.

Clickable hitboxes:

#btn-prev → previous track

#btn-playpause → toggle play/pause (icon swapped depending on state)

#btn-next → next track

#slot-progress → seek bar (draw progress fill rectangle inside; allow click/drag seek)

Data slots:

#slot-title → scrolling marquee for artist — title

#slot-sub → subtitle (album name, or elapsed/total time)

#seat-art → album art thumbnail (optional; fallback to music note icon if none)

Logic

playerctl -p %any metadata --format '{{artist}} — {{title}}' → title.

playerctl -p %any metadata --format '{{album}}' or timecodes → subtitle.

playerctl position / playerctl metadata mpris:length → progress fraction → bar fill.

Album art: playerctl metadata mpris:artUrl → fetch/cache → draw scaled image in #seat-art.

Control Mode (Compact Strip)
Layout

Use media_strip_compact.svg as frame background inside the Control Strip.

Clickable hitboxes:

#btn-prev, #btn-playpause, #btn-next as above.

#slot-progress → thin progress bar (fill line inside).

Data slots:

#slot-title → title string (scroll if too long).

#slot-sub → subtitle (timecodes or artist).

Behavior

Same playerctl logic as Command mode.

Progress bar thinner (height = 6).

Title string truncated with ellipsis when static, or use EWW’s marquee widget.

Icon Swap Rules

Play/Pause:

If playerctl status == Playing → show Pause icon.

Else (Paused, Stopped) → show Play icon.

Icons are centered inside the rect hitboxes.

Color inherits from currentColor → theme can recolor on hover/active.

Update Cadence

Metadata/title update every 1–2s (or on DBus signal).

Progress bar refresh every 0.5–1s.

Album art refresh only on track change.

State detection (Playing/Paused) → poll every 1s or bind to DBus event.

Fallbacks

No player running: hide all controls except Play; #slot-title shows “—”.

Album art missing: fill #seat-art with music glyph icon (clean or glitched).

Multiple players: focus the last active or let user cycle.

Theme Integration

Use CSS classes:

.cp-accent → active states (hover, playing).

.cp-muted → inactive/no track.

.cp-text → title text.

Ensure all fills are currentColor for easy theme swap.

Summary

Command mode: Full-featured media HUD with art + big controls.

Control mode: Slimline variant inside the strip, no art, smaller progress.

Everything runs through playerctl, DBus-aware, with clean fallbacks.