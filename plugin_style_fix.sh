#!/usr/bin/env bash
# plugin_style_fix.sh — bring EML plugin sources into line with the PraatGen
# prohibition list. Praat accepts all of these; they are style, not bugs.
# Run from the plugin root (the folder containing stats/, graphs/, scripts/).
#
#   +=      -> x = x + n      (MP forbids compound assignment)
#   elif    -> elsif          (both parse; elsif is the house form)
#
# Verified against Praat 6.6.30: `elif` and `elsif` are both accepted, and
# every `+=` below is a simple counter or accumulator, so the rewrite is
# mechanical and behaviour-preserving. Back up first; diff after.
set -euo pipefail
command -v python3 >/dev/null || { echo "python3 required" >&2; exit 1; }

python3 - "$@" <<'PY'
import re, sys, glob, os
targets = sys.argv[1:] or glob.glob('**/*.praat', recursive=True)
pat = re.compile(r'^(\s*)([A-Za-z_.][A-Za-z0-9_.$#\[\]]*)\s*\+=\s*(.+?)\s*$')
tot_a = tot_e = 0
for p in targets:
    if not os.path.isfile(p): continue
    src = open(p, encoding='utf-8', errors='replace').read()
    out = []
    na = 0
    for line in src.split('\n'):
        if not line.lstrip().startswith('#'):
            m = pat.match(line)
            if m and not m.group(3).startswith(('#', ';')):
                line = f'{m.group(1)}{m.group(2)} = {m.group(2)} + {m.group(3)}'
                na += 1
        out.append(line)
    txt = '\n'.join(out)
    txt, ne = re.subn(r'^(\s*)elif\b', r'\1elsif', txt, flags=re.M)
    if na or ne:
        open(p, 'w', encoding='utf-8').write(txt)
        print(f'  {p}: += x{na}, elif x{ne}')
        tot_a += na; tot_e += ne
print(f'total: {tot_a} compound assignments, {tot_e} elif rewritten')
PY
