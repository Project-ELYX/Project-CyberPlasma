Place vizframe_skinned.svg as the panel background.

Spawn GLava (or an EWW polyline) behind your overlay text, inside the slot at x=20,y=22,w=440,h=96.

Apply the clip:

EWW polyline → set the plotting canvas to that rect.

GLava → use a KWin rule to size/position the GLava window to the rect and set click-through + no focus; if your compositor won’t clip cleanly, use vizframe_mask.svg as a shaped window region (or let GLava respect window bounds and round the corners slightly).

Keep the panel itself click-through so the strip/panels under it stay interactive.

Update rate: 60 FPS max if GPU is bored; otherwise 30 FPS is more than enough for a smooth look.

No other changes required—this will “snap” visually with the CPU/MEM/NET panels and stays modular for Command or Control modes.