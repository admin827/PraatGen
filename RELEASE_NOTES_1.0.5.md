# EML PraatGen v1.0.5 Release Notes

**1.0.5** (stable)  
**Release date:** 5 August 2026  
**Master Prompt:** 14.17.0  
**PKB snapshot:** 2026-08-05  
**Sandbox Praat:** 6.6.30  
**Praat version floor:** 6.4.39  
**License:** GPL-3.0-or-later — Ian Howell, Embodied Music Lab

| Component      | This release | Previous (1.0.4) |
| -------------- | ------------ | ---------------- |
| Release        | **1.0.5**    | 1.0.4            |
| Master Prompt  | **14.17.0**  | 14.12.0          |
| PKB snapshot   | **2026-08-05** | 2026-07-29     |
| Praat floor    | **6.4.39**   | 6.4.15           |
| Sandbox Praat  | 6.6.30       | 6.6.30           |
| Rules          | 37           | 37               |
| EML procedures | 263 across 15 files | 263       |

Full version history is in `pkb/PRAATGEN_CHANGELOG.md`.

---

## Version check in every generated script

Every generated script opens with a version check, before the first object is
created and before the first file is written.

It reports a list. Each entry names one call the script makes, the Praat release
that call needs, and which of two things happens on your build:

- **STOPS** — the command, function or option value does not exist. Praat errors
  at that line and the script halts.
- **DIFFERS** — the call runs and returns a different number.

Only entries your build is below appear. On a current Praat, nothing appears —
there is no generic "your version is old" notice.

Entries are keyed to the call, not the command name. One command called with
different option values carries different exposure, and each form is reported
separately.

**Run anyway** is the default button; the check never refuses. A "Check again
next time" tickbox records the requirement level dismissed, so switching it off
for one script does not silence a higher requirement later. The full list is
also written to the Info window, where it can be selected and copied.

## Praat version floor: 6.4.39

Praat 6.4.39 is the oldest build a generated script accepts without raising a
version entry. At or above it, nothing prompts you to update on general
principles.

## Axis ticks

Spectrum, Ltas and PowerCepstrum patterns place ticks with the nice-number
procedures throughout, and re-assert `Axes:` after `Draw:`.

`COMMANDS_PictureWindow.txt` documents `Marks left:` and `Marks bottom:` as
do-not-emit.

## Debugging

DEBUGGING mode runs the same pre-delivery self-audit path as autonomous mode.
SELF-AUDIT evidence requires a script line **and** a citation.

---

## Upgrade notes

Replace your project's instructions with `MASTER_PROMPT_CORE_v14_17_0.md`.
Delete `MASTER_PROMPT_CORE_v14_12_0.md` and `MASTER_PROMPT_CORE_v14_15_0.md`.

Replace the entire `pkb/` folder — 63 files. Delete the old folder rather than
overwriting into it.

Do not rename files; the Master Prompt references them by exact filename.

Sandbox Mode requires `www.fon.hum.uva.nl` in Settings → Capabilities → Allowed
domains, set *before* the conversation starts. It installs `openbox`,
`xcompmgr`, `xdotool` and `imagemagick`.

## Reporting issues

Report to Ian Howell at the Embodied Music Lab
([www.embodiedmusiclab.com](https://www.embodiedmusiclab.com)). Quote both the
Release and Master Prompt versions; they track independently.

- **Script errors:** the task description, the generated script, and the exact
  Praat error message with line number.
- **Reference gaps:** the object type and command name.
- **Arity errors:** Praat's "requires only N arguments" message is ground truth
  — include it verbatim.
