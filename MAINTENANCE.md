# PraatGen maintenance checks

Checks for the maintainer, not for a generating session. Deliberately **not**
in `pkb/` — nothing here should ever be retrieved into a script-writing
conversation.

---

## 1. Self-contradiction sweep

**The defect class.** A file states a prohibition, then uses the prohibited
construct in a block that is not labelled WRONG. The prohibition and the
counter-example live in the same file, so no cross-file comparison finds them,
and a model that loads the file and scrolls to the pattern matching its task
gets the wrong answer from the right source.

This class has produced two shipped defects:

- Master Prompt Rule 28H emitted `Marks left:` / `Marks bottom:`, which
  `BEST_PRACTICES_DRAWING.txt` prohibits and Rule 34 lists as an anti-pattern.
- `BEST_PRACTICES_DRAWING.txt`'s own "Pattern for Spectrum" used the same two
  commands, three hundred lines below its own prohibition. A model that loaded
  the file and followed the spectrum pattern — which is what a spectrum task
  does — got the prohibited form from the authoritative source.

Cross-file sweeps miss it. Run this one **within** files, and against the
library source they point at.

**Run it.**

    python3 tools/sweep_self_contradiction.py

Exit code 1 and a printed table if anything is found. Triage every hit — the
check is deliberately noisy and false positives are expected:

- Occurrences inside blocks labelled `WRONG`, `anti-pattern`, or `never` are
  correct and are already filtered.
- A command reference legitimately lists prohibited commands; the entry needs
  a DO-NOT-EMIT note, not deletion. See `COMMANDS_PictureWindow.txt`.
- A worked example demonstrating what the prohibited form produces is correct.
- Hits in `eml-*.txt` are **plugin source, carried verbatim**. Do not edit them
  here. Report them to the plugin maintainer and resync after the fix lands
  upstream, or the PKB copy silently diverges from the plugin.

**Extending it.** `BANNED` in the script maps a regex to the rule it violates.
Add an entry whenever a new hard prohibition enters the PKB. A prohibition
with no sweep entry is one nobody will notice being broken.

---

## 2. Master Prompt code blocks versus their PKB sources

The Master Prompt carries a small number of Praat code blocks. Each is a
copyable answer that can drift from the source it summarises, and nothing
cross-checks them automatically.

    python3 tools/list_mp_code_blocks.py

Read each against the PKB file or library procedure it reflects. Check
procedure names, argument order and argument count against the source, not
against `EML_PROCEDURE_REGISTRY.md` — the registry lists inputs only, and
return variables must be read from the procedure body.

The standing preference is that a block that has drifted once gets **replaced
by a pointer**, not by a corrected block. A pointer cannot go stale and it
forces the load. Rule 28H is the worked example of this; Rule 27's
`@emlGenerateUniquePath` block is the other acceptable shape — it keeps the
code and states explicitly that the library source governs where the two
disagree.

---

## 3. Version and release discipline

- The **release number** (1.0.x) is incremented only when a release is cut.
  It is not bumped per Master Prompt change.
- The **Master Prompt number** (14.x.y) versions the instruction set and moves
  with rule changes. `main` is normally ahead of the last cut release; README
  and the changelog say so.
- Every Master Prompt change gets a `PRAATGEN_CHANGELOG.md` entry and an
  update to the one-line summary in the prompt's CHANGELOG section.

## 4. What belongs in a changelog and what belongs in a PKB file

PKB files are read by a model that needs the current rule. They state what is
true now. They do not carry the history of how a rule was arrived at, which
earlier version was wrong, or what a previous session got wrong — that is
noise at the point of use and it invites a reader to weigh a superseded form.

The changelog carries the history. Corrections, reversals and the reasoning
behind them go there, in full.
