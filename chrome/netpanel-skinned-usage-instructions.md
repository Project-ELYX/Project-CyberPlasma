How to overlay live values (concept):

Put text in each slot-* (absolute positioning to those x/y/width/height).

Place your VPN icon centered in #vpn-badge-seat (and text “WG/OVPN” atop it if you want).

Draw the live sparkline inside #sparkline-safe (a polyline or a path).

For traffic UP/DOWN numbers, write into #slot-up / #slot-down.

All etched labels are decorative; the actual values come from EWW.

Font & baseline notes (ShureTechMono)

The header strip (28px tall) and label baselines assume ~11–12px mono font.

If you bump font size, nudge:

header rect height (28 → 30–32)

label y positions (66/96/132/152/172) by +1–2px

Everything obeys the 8-px base grid, so it will still look aligned post-tweak.