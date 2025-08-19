B) Constrain the title in EWW (so it never bleeds)

Position your title overlay inside that 488×26 rect and clip it:

.media-title {
  position: absolute;
  left: 16px;          /* match title-area x */
  top: 88px;           /* match title-area y */
  width: 488px;        /* match title-area width */
  height: 26px;        /* match title-area height */
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
  text-align: center;  /* or left/right if you prefer */
  line-height: 26px;   /* vertically center text in the band */
}

If you want a marquee on hover:

.media-title:hover {
  animation: scrollx 10s linear infinite;
}
@keyframes scrollx {
  from { transform: translateX(0); }
  to   { transform: translateX(-40%); }
}

And make sure the z-order is sane:

Frame at the bottom,

Then button hit rects,

Icons over the button rects,

Progress fill over the progress slot,

Title text last (but confined to its band).
Nothing should overlap the center button anymore.