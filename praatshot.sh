#!/usr/bin/env bash
# praatshot — reliable X11 window capture under Xvfb.
# Usage: praatshot <outfile.png> [window-name-substring]
#        no name -> captures the whole root window
set -u
out="$1"; want="${2:-}"

[ -n "${DISPLAY:-}" ] || { echo "praatshot: DISPLAY unset" >&2; exit 2; }
xdotool getdisplaygeometry >/dev/null 2>&1 || { echo "praatshot: no X server on $DISPLAY" >&2; exit 2; }

if [ -n "$want" ]; then
  wid=""
  for id in $(xdotool search --onlyvisible --name "." 2>/dev/null); do
    n=$(xdotool getwindowname "$id" 2>/dev/null)
    case "$n" in *"$want"*) wid="$id"; break;; esac
  done
  [ -n "$wid" ] || { echo "praatshot: no visible window matching '$want'" >&2; exit 3; }
  xdotool windowraise "$wid" 2>/dev/null
  sleep 1
  import -window "$wid" "$out" 2>/dev/null
else
  import -window root "$out" 2>/dev/null
fi

[ -s "$out" ] || { echo "praatshot: capture produced no file" >&2; exit 4; }

# validate: an all-black frame means nothing was rendered (app died, or
# obscured with no compositor). Report it rather than returning a dud.
pct=$(python3 - "$out" <<'PY'
import sys
from PIL import Image
im=Image.open(sys.argv[1]).convert('L')
px=list(im.getdata())
print(round(100*sum(1 for p in px if p<8)/len(px),1))
PY
)
echo "praatshot: $out  black=${pct}%"
awk -v p="$pct" 'BEGIN{exit !(p>95)}' && {
  echo "praatshot: WARNING frame is ${pct}% black — target likely not mapped." >&2
  echo "praatshot: check the app is alive (pgrep praat) and a compositor is running (pgrep xcompmgr)." >&2
  exit 5
}
exit 0
